class AddContributionsToGithubRepo < ActiveRecord::Migration
  def change
    add_column :github_repos, :contributions, :integer
  end
end
