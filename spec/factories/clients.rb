FactoryGirl.define do
  factory :client do
    sequence :company do |n|
      "Test Company #{n}"
    end
    association :user, factory: :user_checked_terms
  end
end
