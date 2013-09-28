require 'spec_helper'

feature 'Payment info', js: true do
  scenario 'a person can add a funding source to their account' do
    programmer_sign_up

    click_link 'Settings'

    click_link 'Payments'

    page.should have_content('Payment Sources')
    page.should have_content('Add a Payment Source')

    choose 'Credit Card'

    fill_in 'credit_card', with: '4111111111111111'
    fill_in 'expiration_year', with: '2040'
    fill_in 'expiration_month', with: '10'
    fill_in 'security_code', with: '123'

    click_button 'Save changes'

    page.should have_content("Card Type: Visa")
    page.should have_content("Last Four Digits: 1111")
    page.should have_content("Exp Date: October / 2040")
  end
end
