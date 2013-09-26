class AddClient < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.integer :user_id
      t.string :company
      t.text :description

      t.timestamps
    end
  end
end
