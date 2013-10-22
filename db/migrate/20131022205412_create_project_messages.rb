class CreateProjectMessages < ActiveRecord::Migration
  def change
    create_table :project_messages do |t|
      t.integer :project_id
      t.boolean :sender_is_client
      t.text :content

      t.timestamps

      t.index :project_id
    end
  end
end
