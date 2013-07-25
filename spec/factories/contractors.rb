FactoryGirl.define do
  factory :contractor do
    rate 20
    time_status 'fulltime'
    onsite_status 'offsite'
    user
  end
end
