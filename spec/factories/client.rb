FactoryGirl.define do
  factory :client do
    sequence :company do |n|
      "Test Company #{n}"
    end
    user
  end
end
