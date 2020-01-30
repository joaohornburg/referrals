class User < ApplicationRecord
  before_create :generate_referral_code
  validates_presence_of :name, :email, :password
  validate :readonly_attributes

  private

  def generate_referral_code
    self.referral_code = SecureRandom.uuid
  end

  def readonly_attributes
    if persisted?
      errors.add(:email, 'cannot be changed') if email_changed?
      errors.add(:referral_code, 'cannot be changed') if referral_code_changed?
    end
  end
end
