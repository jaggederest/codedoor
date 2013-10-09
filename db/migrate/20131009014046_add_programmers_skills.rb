class AddProgrammersSkills < ActiveRecord::Migration
  def change
    create_table :programmers_skills do |t|
      t.integer :programmer_id
      t.integer :skill_id

      t.timestamps
    end
    remove_column :skills, :programmer_id, :integer
  end
end
