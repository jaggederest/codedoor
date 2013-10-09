require 'spec_helper'

feature 'Programmer settings', js: true do
  scenario 'programmer sign up and editing' do
    programmer_sign_up

    page.should have_content 'Your programmer account has been created.'
    page.should have_content 'Test User'
    page.should have_content 'Test Title'
    page.should have_content '$900 / day'
    page.should have_content 'Full-time'
    page.should have_content 'Work can be done at a client\'s office if it is nearby.'
    page.should have_content 'Skills: Android'

    click_link 'Settings'
    page.should_not have_content 'By checking this box, I agree to abide by CodeDoor\'s Terms of Use.'
    click_link 'Programmer Info'

    choose('Part-time')

    fill_in 'hourly_rate_to_programmer', with: 50
    click_button 'Edit Info'
    page.should have_content 'Your programmer account has been updated.'
    page.should have_content '$450 / 8 hours'
  end

  scenario 'Modifying rates', js: true do
    programmer_sign_up
    go_to_programmer_settings

    page.should have_content('As a full-time programmer, billing is generally done a daily basis. The hourly rate is used when you spend an hour or two with a client.')

    find('#hourly_rate_to_programmer').trigger('blur')
    page.should have_content('$800/day')

    choose('Part-time')

    page.should_not have_content('As a full-time programmer, billing is generally done a daily basis. The hourly rate is used when you spend an hour or two with a client.')
    page.should_not have_content('$800/day')
  end

  scenario 'Add project, resume, and education', js: true do
    programmer_sign_up
    go_to_programmer_settings

    click_link 'Add project'
    find('input[id^="programmer_portfolio_items_attributes_"][id$="_title"]').set('Test Project')
    find('input[id^="programmer_portfolio_items_attributes_"][id$="_url"]').set('codedoor.com')
    find('textarea[id^="programmer_portfolio_items_attributes_"][id$="_description"]').set('Random Website')

    find('a[data-blueprint-id="resume_items_fields_blueprint"]').click
    find('input[id^="programmer_resume_items_attributes_"][id$="_company_name"]').set('CodeDoor')
    find('input[id^="programmer_resume_items_attributes_"][id$="_title"]').set('Software Programmer')
    find('textarea[id^="programmer_resume_items_attributes_"][id$="_description"]').set('Building a Website.')
    find('select[id^="programmer_resume_items_attributes_"][id$="_month_started"]').find(:option, 'July').select_option
    find('input[id^="programmer_resume_items_attributes_"][id$="_year_started"]').set('2013')
    page.should have_content 'Finished'
    check('is-current-resume-')
    page.should_not have_content 'Finished'

    click_link 'Add to education'
    find('input[id^="programmer_education_items_attributes_"][id$="_school_name"]').set('Columbia')
    find('input[id^="programmer_education_items_attributes_"][id$="_degree_and_major"]').set('BS Computer Science')
    find('textarea[id^="programmer_education_items_attributes_"][id$="_description"]').set('College')
    find('select[id^="programmer_education_items_attributes_"][id$="_month_started"]').find(:option, 'September').select_option
    find('input[id^="programmer_education_items_attributes_"][id$="_year_started"]').set('2003')
    find('select[id^="programmer_education_items_attributes_"][id$="_month_finished"]').find(:option, 'May').select_option
    find('input[id^="programmer_education_items_attributes_"][id$="_year_finished"]').set('2007')

    click_button 'Edit Info'

    go_to_programmer_settings

    find('#programmer_portfolio_items_attributes_0_title').value.should eq('Test Project')
    find('#programmer_portfolio_items_attributes_0_url').value.should eq('http://codedoor.com')
    find('#programmer_portfolio_items_attributes_0_description').value.should eq('Random Website')

    find('#programmer_resume_items_attributes_0_company_name').value.should eq('CodeDoor')
    find('#programmer_resume_items_attributes_0_title').value.should eq('Software Programmer')
    find('#programmer_resume_items_attributes_0_description').value.should eq('Building a Website.')
    find('#programmer_resume_items_attributes_0_month_started').value.should eq('7')
    find('#programmer_resume_items_attributes_0_year_started').value.should eq('2013')

    find('#programmer_education_items_attributes_0_school_name').value.should eq('Columbia')
    find('#programmer_education_items_attributes_0_degree_and_major').value.should eq('BS Computer Science')
    find('#programmer_education_items_attributes_0_description').value.should eq('College')
    find('#programmer_education_items_attributes_0_month_started').value.should eq('9')
    find('#programmer_education_items_attributes_0_year_started').value.should eq('2003')
    find('#programmer_education_items_attributes_0_month_finished').value.should eq('5')
    find('#programmer_education_items_attributes_0_year_finished').value.should eq('2007')
  end

  scenario 'add repositories', js: true do
    programmer_sign_up
    go_to_programmer_settings

    repo_owner = 'test-repo-owner'
    repo_name = 'test-repo-name'

    GithubUserAccount.any_instance.should_receive(:get_contributors).with(repo_owner, repo_name).and_return([Hashie::Mash.new(login: 'test-username', contributions: 5)])

    sample_repo = Hashie::Mash.new({forks_count: 1, watchers_count: 1, language: 'Ruby', fork: true, owner: Hashie::Mash.new(login: 'test-repo-owner'), name: 'test-repo-name', default_branch: 'master', description: 'Test'})

    GithubUserAccount.any_instance.should_receive(:fetch_repo).and_return(sample_repo)

    fill_in 'repo-owner', with: repo_owner
    fill_in 'repo-name', with: repo_name
    click_link 'Add'

    page.should have_content 'Your contributions to test-repo-owner/test-repo-name have been added.'
    page.text.should match(/test-repo-owner\/test-repo-name.*1 star.*(fork)/)

    find('#shown-github-1').checked?.should be_true
    find('#shown-github-1').set(false)

    click_button 'Edit Info'

    go_to_programmer_settings

    find('#shown-github-1').checked?.should be_false
  end
end
