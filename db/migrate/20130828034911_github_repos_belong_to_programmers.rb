class GithubReposBelongToProgrammers < ActiveRecord::Migration
  def change
    rename_column :github_repos, :user_id, :programmer_id
  end
end
