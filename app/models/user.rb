class User < ApplicationRecord
    has_secure_password
    enum role: [ :guest, :regular, :admin ]
end
