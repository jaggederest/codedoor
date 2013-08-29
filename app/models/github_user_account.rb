class GithubUserAccount < UserAccount
  def verify_repo(repo_org, repo_name)
  end

  # This gets the public repos that are *owned* by the programmer
  def get_repos
    raise 'User must have programmer account to get GitHub repos' if self.user.programmer.nil?
    github = Github.new
    github.oauth_token = oauth_token
    github.repos.list({auto_pagination: true}).each do |r|
      next if r.private?
      repo = GithubRepo.new(programmer_id: self.user.programmer.id)
      repo.default_branch = r.default_branch
      repo.forks_count = r.forks_count
      # NOTE: Watching and starring used to be the same, hence the naming discrepancy
      repo.stars_count = r.watchers_count
      repo.language = r.language
      repo.is_fork = r.fork?
      repo.repo_owner = r.owner.login
      repo.repo_name = r.name
      repo.description = r.description
      repo.save!
    end
  end
end
