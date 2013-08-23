class CreatePortfolio < ActiveRecord::Migration
  def change
    create_table :github_repos do |t|
      t.integer :user_id
      t.string :repo_org
      t.string :repo_name
      t.boolean :hidden

      t.timestamps
    end

    create_table :portfolio_items do |t|
      t.string :title
      t.string :url
      t.text :description

      t.timestamps
    end

    create_table :skills do |t|
      t.string :title

      t.timestamps
    end

    create_table :user_skills do |t|
      t.integer :user_id
      t.integer :skill_id

      t.timestamps
    end

    create_table :resume_items do |t|
      t.integer :user_id
      t.string :company_name
      t.string :title
      t.integer :year_started
      t.integer :year_finished
      t.text :description

      t.timestamps
    end

  end
end
