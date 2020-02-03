class UserCreator
  def initialize(user:, referral_code: nil)
    @user = user
    @referral_code = referral_code
  end

  def create
    user = User.new(@user)
    return user unless user.valid?
    
    if  @referral_code && referrer
      user.balance = 10.0
      referrer.referrals << Referral.new(referred_user: user)
      if referrer.referrals.count == 5
        referrer.update!(balance: @referrer.balance + 10)
      end
    end
    user.save
    user
  end

  private

  def referrer
    @referrer ||= User.find_by(referrer_code: @referral_code)
  end
end