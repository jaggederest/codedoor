class GithubUserAccount < UserAccount
  def verify_contribution(repo_owner, repo_name)
    matching_repo = self.user.programmer.github_repos.named(repo_owner, repo_name).first
    raise GithubApiError.new('This repository has already been added.') unless matching_repo.nil?

    contributions = contributed_query(repo_owner, repo_name)

    if contributions[:contributed]
      repo = GithubRepo.new(programmer_id: self.user.programmer.id, shown: true)
      repo.contributions = contributions[:count]
      return create_repo(repo, repo_owner, repo_name)
    end

    raise GithubApiError.new('You have not contributed any code to this repository.')
  end

  # This gets the public repos that are *owned* by the programmer
  def load_repos
    existing_repos = self.user.programmer.github_repos
    show_repos = (existing_repos.count == 0)
    fetch_user_repos.each do |r|
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

  def fetch_repo(repo_owner, repo_name)
    github_client.repos.get(repo_owner, repo_name)
  end

  def fetch_user_repos
    github_client.repos.list({auto_pagination: true})
  end

  def assign_repo_info_to_repo_model(repo_object, repo_info)
    repo_object.default_branch = repo_info.default_branch.blank? ? 'master' : repo_info.default_branch
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
      raise GithubApiError.new('The repository does not exist.')
    end
  end

  def contributed_query(repo_owner, repo_name)
    contributors = get_contributors(repo_owner, repo_name)
    if contributors.count == 0
      # If a 202 response occurs, that means that GitHub is generating the statistics.
      sleep(3)
      contributors = get_contributors(repo_owner, repo_name)
    end
    contributions = contributors.detect{|c| c.login == username}

    data = {contributed: nil, count: nil}

    # The API only returns 100 contributors, so scrape HTML for more popular repos
    data[:contributed] = contributions.present? || (contributors.count == 100 && ScrapeHtml.is_contributor_through_html?(username, repo_owner, repo_name))
    data[:count] = contributions.contributions if contributions.present?
    data
  end

end

class GithubApiError < StandardError; end
