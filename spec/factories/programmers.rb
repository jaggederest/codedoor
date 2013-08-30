FactoryGirl.define do
  factory :programmer do
    title 'Test Title'
    rate 20
    availability 'full-time'
    onsite_status 'offsite'
    visibility 'codedoor'
    user
  end
end
