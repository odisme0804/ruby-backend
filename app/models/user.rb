class User < ApplicationRecord
    has_many :purchase_records
    has_secure_password
end
