class GithubUserAccount < UserAccount
  def verify_repo(repo_org, repo_name)
  end

  # This gets the public repos that are *owned* by the programmer
  def load_repos
    existing_repos = self.user.programmer.github_repos
    fetch_repos(github_client).each do |r|
      next if r.private?
      repo_owner = r.owner.login
      repo_name = r.name
      next if existing_repos.where(repo_owner: repo_owner, repo_name: repo_name).count > 0
      repo = GithubRepo.new(programmer_id: self.user.programmer.id, shown: (existing_repos.count == 0))
      repo.default_branch = r.default_branch
      repo.forks_count = r.forks_count
      # NOTE: Watching and starring used to be the same, hence the naming discrepancy
      repo.stars_count = r.watchers_count
      repo.language = r.language
      repo.is_fork = r.fork?
      repo.repo_owner = repo_owner
      repo.repo_name = repo_name
      repo.description = r.description
      repo.save!
    end
  end

  private

  def github_client
    raise 'User must have programmer account to call GitHub' if self.user.programmer.nil?
    github = Github.new
    github.oauth_token = oauth_token
    github
  end

  def fetch_repos(client)
    client.repos.list({auto_pagination: true})
  end
end
