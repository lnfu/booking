class User < ApplicationRecord
    has_secure_password
    enum role: [ :guest, :regular, :admin ]
    
    def generate_password_reset_token!
        self.password_reset_token = SecureRandom.urlsafe_base64
        self.password_reset_token_expire_at = Time.now + 1.hour
        save!
        # TODO error handling
    end
end
