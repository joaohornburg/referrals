class User < ApplicationRecord
  has_secure_password
  before_create :generate_referrer_code

  validates_presence_of :name, :email, :password
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :readonly_attributes

  has_many :referrals, foreign_key: :referring_user_id

  def public_attributes
    {
      name: self.name,
      email: self.email,
      created_at: self.created_at
    }
  end

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
