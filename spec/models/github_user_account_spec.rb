require 'spec_helper'

describe GithubUserAccount do
  def example_repo_data
    repo_data = Hashie::Mash.new
    repo_data.default_branch = 'master'
    repo_data.forks_count = 25
    repo_data.watchers_count = 15
    repo_data.language = 'Ruby'
    repo_data.fork = false
    repo_data.name = 'test name'
    repo_data.description = 'test description'
    repo_owner_data = Hashie::Mash.new
    repo_owner_data.login = 'test-user'
    repo_data.owner = repo_owner_data
    repo_data
  end

  context 'load_repos' do
    before :each do
      @user_account = FactoryGirl.create(:github_user_account)
      @programmer = FactoryGirl.create(:programmer, user: @user_account.user)
    end

    it 'should create repos when called, but not create duplicates' do
      @user_account.should_receive(:fetch_user_repos).at_least(:once) { [example_repo_data] }
      @user_account.load_repos

      repos = @programmer.github_repos
      repos.count.should eq(1)
      repo = repos.first

      repo.default_branch.should eq('master')
      repo.forks_count.should eq(25)
      repo.stars_count.should eq(15)
      repo.language.should eq('Ruby')
      repo.is_fork.should be_false
      repo.repo_owner.should eq('test-user')
      repo.repo_name.should eq('test name')
      repo.description.should eq('test description')
      repo.shown.should be_true

      @user_account.load_repos

      repos = @programmer.reload.github_repos
      repos.count.should eq(1)
    end

    # NOTE: Should we delete repos that stop showing up?
    # That can lead to terrible edge cases where all repos are deleted.
    it 'should add a repo that is different from what is currently stored' do
      @user_account.should_receive(:fetch_user_repos).at_least(:once) { [example_repo_data] }
      @user_account.load_repos

      repos = @programmer.reload.github_repos
      repos.count.should eq(1)

      other_repo_data = example_repo_data
      other_repo_data.name = 'other-repo'

      # TODO: Fix hack where should_receive cannot be overwritten.
      # We can't use stub because fetch_repos is private.
      reloaded_user_account = @user_account.user.user_accounts.first
      reloaded_user_account.should_receive(:fetch_user_repos).at_least(:once) { [example_repo_data, other_repo_data] }
      reloaded_user_account.load_repos

      repos = @programmer.reload.github_repos
      repos.count.should eq(2)
      [repos[0].repo_name, repos[1].repo_name].sort.should eq([example_repo_data.name, other_repo_data.name].sort)

      # The first repo should be shown by default, and the second one should be hidden by default
      repos.each do |repo|
        repo.shown.should be_true if repo.repo_name == example_repo_data.name
        repo.shown.should be_false if repo.repo_name == other_repo_data.name
      end
    end

    it 'should make repo default branch master if it is blank' do
      repo_data = example_repo_data
      repo_data.default_branch = ''
      @user_account.should_receive(:fetch_user_repos).at_least(:once) { [repo_data] }
      @user_account.load_repos

      @programmer.reload.github_repos.first.default_branch.should eq('master')
    end

    it 'should not add private repos' do
      repo_data = example_repo_data
      repo_data.private = true

      @user_account.should_receive(:fetch_user_repos) { [repo_data] }
      @user_account.load_repos

      @programmer.reload.github_repos.should eq([])
    end

    it 'should raise an error if the user does not have a programmer account' do
      @user_account = FactoryGirl.create(:github_user_account)
      @user_account = @user_account.user.user_accounts.first
      -> { @user_account.load_repos }.should raise_error
    end
  end
end
