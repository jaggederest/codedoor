class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.integer :programmer_id
      t.string :name
      t.timestamps

      t.index :name
    end
  end
end
