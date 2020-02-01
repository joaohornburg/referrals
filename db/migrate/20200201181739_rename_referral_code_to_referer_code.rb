class RenameReferralCodeToRefererCode < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :referral_code, :referrer_code
  end
end
