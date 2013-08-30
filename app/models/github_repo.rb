class GithubRepo < ActiveRecord::Base
  belongs_to :programmer

  validates :programmer_id, presence: true
  validates :repo_owner, presence: true
  validates :repo_name, presence: true
  validates :default_branch, presence: true
end
