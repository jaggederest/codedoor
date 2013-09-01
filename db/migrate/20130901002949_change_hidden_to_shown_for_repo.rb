class ChangeHiddenToShownForRepo < ActiveRecord::Migration
  # If this site were live, we would have to flip the bits, but we don't!
  def change
    rename_column :github_repos, :hidden, :shown
  end
end
