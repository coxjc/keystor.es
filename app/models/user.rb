class User < ApplicationRecord

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, :uniqueness => {case_sensitive: false}
  validates :name, :email, :password, :password_confirmation, :presence => true
  validates :email, format: {with: VALID_EMAIL_REGEX}
  validates :password, :length => {minimum: 6}

  before_save :save_uppercase

  def save_uppercase
    self.name.upcase!
    self.email.upcase!
  end

  has_secure_password

end
