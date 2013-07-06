FactoryGirl.define do
  factory :user do
    sequence :full_name do |n|
      "Test User #{n}"
    end
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password 'fakepassword'
  end
end
