FactoryGirl.define do
  factory :contractor do
    title 'Test Title'
    rate 20
    time_status 'full-time'
    onsite_status 'offsite'
    user
  end
end
