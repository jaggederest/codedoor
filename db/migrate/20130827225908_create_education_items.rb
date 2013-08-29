class CreateEducationItems < ActiveRecord::Migration
  def change
    create_table :education_items do |t|
      t.integer :programmer_id
      t.string :school_name
      t.string :degree_and_major
      t.text :description
      t.integer :year_started
      t.integer :year_finished

      t.timestamps
    end
  end
end
