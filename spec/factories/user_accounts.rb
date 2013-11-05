FactoryGirl.define do
  factory :user_account, aliases: [:github_user_account], class: 'GithubUserAccount' do
    sequence :account_id do |n|
      "github account #{n}"
    end
    sequence :username do |n|
      "username-#{n}"
    end
    before :create do |instance|
      instance.oauth_token = ENV['TEST_OAUTH_TOKEN'] || 'hats'
    end
    user
  end
end
