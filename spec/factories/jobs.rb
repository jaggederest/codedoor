FactoryGirl.define do
  factory :job do
    client
    programmer
    rate 50
    availability 'full-time'
    sequence :name do |n|
      "Test Job #{n}"
    end
  end
end
