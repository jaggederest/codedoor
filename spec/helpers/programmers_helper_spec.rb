require 'spec_helper'

describe ProgrammersHelper do
  describe 'contribution links' do
    before :each do
      @programmer = FactoryGirl.create(:programmer)
      @github_user_account = FactoryGirl.create(:github_user_account, user: @programmer.user, username: 'username')
      @repo1 = FactoryGirl.create(:github_repo, repo_name: 'repo1', repo_owner: 'owner', programmer: @programmer, shown: false, stars_count: 15)
      @repo2 = FactoryGirl.create(:github_repo, repo_name: 'repo2', repo_owner: 'owner', programmer: @programmer, shown: true, stars_count: 2)
      @repo3 = FactoryGirl.create(:github_repo, repo_name: 'repo3', repo_owner: 'owner', programmer: @programmer, shown: false, stars_count: 2)
      @repo4 = FactoryGirl.create(:github_repo, repo_name: 'repo4', repo_owner: 'owner', programmer: @programmer, shown: true, stars_count: 5)
      @repo5 = FactoryGirl.create(:github_repo, repo_name: 'repo5', repo_owner: 'owner', programmer: @programmer, shown: false, stars_count: 0)
      @repo6 = FactoryGirl.create(:github_repo, repo_name: 'repo6', repo_owner: 'owner', programmer: @programmer, shown: true, stars_count: 10)
      @repo7 = FactoryGirl.create(:github_repo, repo_name: 'repo7', repo_owner: 'owner', programmer: @programmer, shown: true, stars_count: 0)
    end

    it 'should show up to 3 shown repos in order of stars' do
      contribution_links(@programmer).should eq(["<a href=\"https://github.com/owner/repo6/commits?author=username\" target=\"_blank\">repo6</a>", "<a href=\"https://github.com/owner/repo4/commits?author=username\" target=\"_blank\">repo4</a>", "<a href=\"https://github.com/owner/repo2/commits?author=username\" target=\"_blank\">repo2</a>"])
    end

    it 'should respect limit parameter' do
      contribution_links(@programmer, 1).should eq(["<a href=\"https://github.com/owner/repo6/commits?author=username\" target=\"_blank\">repo6</a>"])
    end
  end
end
