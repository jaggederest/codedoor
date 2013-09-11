require 'spec_helper'

feature 'Programmer settings', js: true do
  scenario 'programmer sign up and editing' do
    programmer_sign_up

    page.should have_content 'Your programmer account has been created.'
    page.should have_content 'Test User'
    page.should have_content 'Test Title'
    page.should have_content '$900 per day'
    page.should have_content 'Full Time'
    page.should have_content 'Work can be done at a client\'s office if it is nearby.'

    click_link 'Edit Basic Info'
    page.should_not have_content 'By checking this box, I agree to abide by CodeDoor\'s Terms of Use.'
    click_button 'Edit Info'

    choose('Full-time')

    page.should have_content('As a full-time programmer, billing is generally done a daily basis. The hourly rate is used when you spend an hour or two with a client.')

    find('#hourly_rate_to_programmer').trigger('blur')
    page.should have_content('$800/day')

    choose('Part-time')

    page.should_not have_content('As a full-time programmer, billing is generally done a daily basis. The hourly rate is used when you spend an hour or two with a client.')
    page.should_not have_content('$800/day')

    fill_in 'hourly_rate_to_programmer', with: 50
    click_button 'Edit Info'
    page.should have_content 'Your programmer account has been updated.'
    page.should have_content '$450 per day'
  end

  scenario 'add repositories', js: true do
    programmer_sign_up
    click_link 'Settings'
    click_link 'Programmer Info'

    repo_owner = 'test-repo-owner'
    repo_name = 'test-repo-name'

    GithubUserAccount.any_instance.should_receive(:get_contributors).with(repo_owner, repo_name).and_return([Hashie::Mash.new(login: 'test-username', contributions: 5)])

    sample_repo = Hashie::Mash.new({forks_count: 1, watchers_count: 1, language: 'Ruby', fork: true, owner: Hashie::Mash.new(login: 'test-repo-owner'), name: 'test-repo-name', default_branch: 'master', description: 'Test'})

    GithubUserAccount.any_instance.should_receive(:fetch_repo).and_return(sample_repo)

    fill_in 'repo-owner', with: repo_owner
    fill_in 'repo-name', with: repo_name
    click_link 'Add'

    page.should have_content 'test-repo-owner/test-repo-name (fork) 1 star'
    page.should have_content 'Your contributions to test-repo-owner/test-repo-name have been added.'

    find('#shown-github-0').checked?.should be_true
    find('#shown-github-0').set(false)

    click_button 'Edit Info'

    click_link 'Settings'
    click_link 'Programmer Info'

    find('#shown-github-0').checked?.should be_false
  end
end
