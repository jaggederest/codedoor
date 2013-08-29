class AddColumnsToGithubRepos < ActiveRecord::Migration
  def change
    add_column :github_repos, :default_branch, :string
    add_column :github_repos, :forks_count, :integer
    add_column :github_repos, :stars_count, :integer
    add_column :github_repos, :language, :string
    add_column :github_repos, :is_fork, :boolean
    add_column :github_repos, :description, :text
    rename_column :github_repos, :repo_org, :repo_owner
  end
end
