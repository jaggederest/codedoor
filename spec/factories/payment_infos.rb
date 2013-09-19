FactoryGirl.define do
  factory :payment_info do
    primary_payment_method 'balanced'
    user
  end
end
