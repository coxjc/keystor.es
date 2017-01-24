class User < ApplicationRecord

  attr_accessor :reset_token

  has_many :keystores, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, :uniqueness => {case_sensitive: false}
  validates :name, :email, :password, :password_confirmation, :presence => true
  validates :email, format: {with: VALID_EMAIL_REGEX}
  validates :password, :length => {minimum: 6}

  before_save :save_uppercase
  before_create :confirmation_token


  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_digest = SecureRandom.urlsafe_base64.to_s
    update_attribute(:reset_digest, reset_digest)
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(:validate => false)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver
  end

  def update_membership(tf)
    if tf
      self.stripe_end_date = Date.today + 1.month
    end
  end

  def has_valid_membership?
    stripe_end_date && Date.today <= stripe_end_date
  end

  has_secure_password

  private

  def save_uppercase
    self.name.upcase!
    self.email.upcase!
  end

  def confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end

end
