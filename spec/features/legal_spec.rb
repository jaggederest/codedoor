require 'spec_helper'

feature 'Terms of Use' do
  scenario 'should show up properly' do
    visit '/'
    click_link 'Terms of Use'
    page.should have_content 'This CodeDoor User Agreement'
  end
end
