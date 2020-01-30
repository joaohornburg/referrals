class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password, null: false
      t.decimal :balance, precision: 9, scale: 2, default: 0.0
      t.string :referral_code, null: false

      t.timestamps
    end
  end
end
