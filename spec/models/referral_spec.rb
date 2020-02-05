require 'rails_helper'

RSpec.describe Referral, type: :model do
  describe '.referred_users' do
    let(:user) { User.create(name: 'User Name', email: 'email@example.com', password: 'password') }
    let(:referred_user_1) { User.create(name: 'Referred User 1', email: 'referred1@example.com', password: 'password') }
    let(:referred_user_2) { User.create(name: 'Referred User 2', email: 'referred2@example.com', password: 'password') }

    before do
      user.referrals << Referral.new(referred_user: referred_user_1)
      user.referrals << Referral.new(referred_user: referred_user_2)
    end

    it 'returns referred users' do
      expect(user.referrals.referred_users).to include(referred_user_1)
      expect(user.referrals.referred_users).to include(referred_user_2)
    end
  end
end
