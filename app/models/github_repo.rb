class GithubRepo < ActiveRecord::Base
  SHOWN = 12

  default_scope { order('shown DESC, stars_count DESC') }

  scope :named, ->(owner, name) { where(repo_owner: owner, repo_name: name) }
  scope :shown, -> { where(shown: true) }

  belongs_to :programmer

  validates :programmer_id, presence: true
  validates :repo_owner, presence: true
  validates :repo_name, presence: true, uniqueness: {scope: :repo_owner}
  validates :default_branch, presence: true

  after_save :qualify_programmer

  def self.repo_commits_url(username, repo_owner, repo_name)
    "https://github.com/#{repo_owner}/#{repo_name}/commits?author=#{username}"
  end

  private

  def qualify_programmer
    if stars_count.to_i >= 25
      self.programmer.qualified = true
      self.programmer.save(validate: false)
    end
  end

end
