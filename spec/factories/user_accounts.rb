FactoryGirl.define do
  factory :user_account do
    sequence :account_id do |n|
      "github account #{n}"
    end
    sequence :oauth_token do |n|
      "oauth token #{n}"
    end
    sequence :username do |n|
      "username-#{n}"
    end
    type 'GithubUserAccount'
    user
  end
end
