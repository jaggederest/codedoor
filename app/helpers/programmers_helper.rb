module ProgrammersHelper
  def contribution_links(programmer, limit=3)
    programmer.github_repos.shown.order('stars_count DESC').limit(limit).map do |repo|
      link_to(repo.repo_name, GithubRepo.repo_commits_url(programmer.username, repo.repo_owner, repo.repo_name), target: '_blank')
    end
  end
end
