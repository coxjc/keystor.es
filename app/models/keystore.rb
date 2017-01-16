class Keystore < ApplicationRecord
  belongs_to :user
  before_save :save_uppercase

  validates_presence_of :name
  validates_uniqueness_of :name, scope: [:user_id]
  validates_length_of :name, :in => 1..100

  def save_uppercase
    self.name.upcase!
  end

end
