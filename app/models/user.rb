class User < ApplicationRecord
    has_secure_password
    enum role: [ :guest, :regular, :admin ]
    has_many :reservations, dependent: :delete_all
end
