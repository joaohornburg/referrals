class CreateReferrals < ActiveRecord::Migration[6.0]
  def change
    create_table :referrals do |t|
      t.references :referred_user, null: false, foreign_key: { to_table: :users }
      t.references :referring_user, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
