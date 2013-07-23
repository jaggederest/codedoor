class CreateContractors < ActiveRecord::Migration
  def change
    create_table :contractors do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.integer :rate
      t.string :time_status
      t.boolean :client_can_visit

      t.timestamps
    end
  end
end
