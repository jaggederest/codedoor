class AddProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :programmer_id
      t.integer :client_id
      t.string  :state
      t.integer :rate
      t.string  :name

      t.index :programmer_id
      t.index :client_id

      t.timestamps
    end
  end
end
