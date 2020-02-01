class User < ApplicationRecord
  before_create :generate_referrer_code
  validates_presence_of :name, :email, :password
  validate :readonly_attributes

  private

  def generate_referrer_code
    self.referrer_code = SecureRandom.uuid
  end

  def readonly_attributes
    if persisted?
      errors.add(:email, 'cannot be changed') if email_changed?
      errors.add(:referrer_code, 'cannot be changed') if referrer_code_changed?
    end
  end
end
