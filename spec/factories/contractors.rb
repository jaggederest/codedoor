FactoryGirl.define do
  factory :contractor do
    title 'Test Title'
    rate 20
    time_status 'fulltime'
    onsite_status 'offsite'
    user
  end
end
