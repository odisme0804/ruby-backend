class User < ApplicationRecord
    has_many :records
    has_secure_password
end
