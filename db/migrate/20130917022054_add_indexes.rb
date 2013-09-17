class AddIndexes < ActiveRecord::Migration
  def change
    add_index :education_items, :programmer_id
    add_index :github_repos, :programmer_id
    add_index :portfolio_items, :programmer_id
    add_index :programmers, :user_id
    add_index :resume_items, :programmer_id
    add_index :user_accounts, :user_id

    remove_index :user_accounts, column: [:account_id, :type]

    drop_table :skills
    drop_table :user_skills
  end
end
