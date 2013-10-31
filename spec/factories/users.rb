FactoryGirl.define do
  factory :user do
    sequence :full_name do |n|
      "Test User #{n}"
    end
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password 'fakepassword'

    factory :user_checked_terms do
      city 'Vancouver'
      country 'CA'
    end

  end
end
