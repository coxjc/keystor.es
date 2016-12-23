class User < ApplicationRecord

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

    validates :name, :email, :presence => true
    validates :email, :uniqueness => true
    validates :email, format: {with: VALID_EMAIL_REGEX}

    has_secure_password
    
end
