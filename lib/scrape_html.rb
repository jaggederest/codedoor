class ScrapeHtml
  def self.is_contributor_through_html?(username, repo_owner, repo_name)
    html = RestClient.get(GithubRepo.repo_commits_url(username, repo_owner, repo_name))
    html.include?('Browse code') && !html.include?('No commits found')
  end
end
