FactoryGirl.define do
  factory :user_account do
    sequence :account_id do |n|
      "github account #{n}"
    end
    sequence :oauth_token do |n|
      "oauth token #{n}"
    end
    provider 'github'
    user
  end
end
