class AddPaymentInfo < ActiveRecord::Migration
  def change
    create_table :payment_infos do |t|
      t.integer :user_id
      t.index :user_id
      t.string :primary_payment_method

      t.timestamps
    end
  end
end
