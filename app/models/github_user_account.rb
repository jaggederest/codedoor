class GithubUserAccount < UserAccount
  def verify_contribution(repo_owner, repo_name)
    matching_repo = self.user.programmer.github_repos.named(repo_owner, repo_name).first
    raise 'This repository has already been added.' unless matching_repo.nil?

    contributors = get_contributors(repo_owner, repo_name)
    if contributors.count == 0
      # If a 202 response occurs, that means that GitHub is generating the statistics.
      sleep(3)
      contributors = get_contributors(repo_owner, repo_name)
    end
    contributions = contributors.detect{|c| c.login == username}

    if contributions.present?
      repo = GithubRepo.new(programmer_id: self.user.programmer.id, shown: true)
      # Probably would have to refresh daily to make this count worthwhile
      repo.contributions = contributions.contributions
      return create_repo(repo, repo_owner, repo_name)
    elsif contributors.count == 100 && ScrapeHtml.is_contributor_through_html?(username, repo_owner, repo_name)
      # NOTE: You cannot use the API to determine if the user is the 101st contributor.
      # So scrape the HTML!
      repo = GithubRepo.new(programmer_id: self.user.programmer.id, shown: true)
      return create_repo(repo, repo_owner, repo_name)
    end
    raise 'You have not contributed any code to this repository.'
  end

  # This gets the public repos that are *owned* by the programmer
  def load_repos
    existing_repos = self.user.programmer.github_repos
    show_repos = (existing_repos.count == 0)
    fetch_user_repos(github_client).each do |r|
      next if r.private? || (existing_repos.named(r.owner.login, r.name).count > 0)
      repo = GithubRepo.new(programmer_id: self.user.programmer.id, shown: show_repos)
      assign_repo_info_to_repo_model(repo, r)
    end
  end

  private

  def github_client
    raise 'User must have programmer account to call GitHub' if self.user.programmer.nil?
    github = Github.new
    github.oauth_token = oauth_token
    github
  end

  def fetch_repo(client, repo_owner, repo_name)
    client.repos.get(repo_owner, repo_name)
  end

  def fetch_user_repos(client)
    client.repos.list({auto_pagination: true})
  end

  def assign_repo_info_to_repo_model(repo_object, repo_info)
    repo_object.default_branch = repo_info.default_branch
    repo_object.forks_count = repo_info.forks_count
    # NOTE: Watching and starring used to be the same, hence the naming discrepancy
    repo_object.stars_count = repo_info.watchers_count
    repo_object.language = repo_info.language
    # NOTE: Should fix in GitHub API client- fork? works for the repos list, since it is a Mashie,
    # but not when calling for a specific one, as that is a ResponseWrapper.
    repo_object.is_fork = repo_info.fork
    repo_object.repo_owner = repo_info.owner.login
    repo_object.repo_name = repo_info.name
    repo_object.description = repo_info.description
    repo_object.save!
    repo_object
  end

  def create_repo(repo_object, repo_owner, repo_name)
    return assign_repo_info_to_repo_model(repo_object, fetch_repo(repo_owner, repo_name))
  end

  def get_contributors(repo_owner, repo_name)
    begin
      github_client.repos.contributors(repo_owner, repo_name)
    rescue Exception => e
      raise 'The repository does not exist.'
    end
  end

end
