class User < ApplicationRecord
  before_create :generate_referral_code
  validates_presence_of :name, :email, :password
  attr_readonly :email, :referral_code

  private

  def generate_referral_code
    self.referral_code = SecureRandom.uuid
  end
end
