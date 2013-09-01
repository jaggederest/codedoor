class GithubRepo < ActiveRecord::Base
  default_scope { order('shown DESC, stars_count DESC') }

  belongs_to :programmer

  validates :programmer_id, presence: true
  validates :repo_owner, presence: true
  validates :repo_name, presence: true, uniqueness: {scope: :repo_owner}
  validates :default_branch, presence: true
end
