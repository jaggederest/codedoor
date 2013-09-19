require 'spec_helper'

describe PaymentInfo do
  context 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_uniqueness_of(:user_id) }
    it { ensure_inclusion_only_of(PaymentInfo, :primary_payment_method, ['paypal', 'balanced']) }
  end

  context 'associations' do
    it { should belong_to(:user) }
  end

  context 'abilities' do
    let(:user) { FactoryGirl.create(:user) }
    let(:ability) { Ability.new(user) }
    let(:payment_info) { FactoryGirl.create(:payment_info, user: user) }

    it 'show allow a user to manage payment info that belongs to the user' do
      ability.should be_able_to(:read, payment_info)
      ability.should be_able_to(:create, payment_info)
      ability.should be_able_to(:update, payment_info)
      ability.should be_able_to(:destroy, payment_info)
    end

    it 'should not allow a user to see another user\'s payment info' do
      other_info = FactoryGirl.create(:payment_info)
      ability.should_not be_able_to(:read, other_info)
      ability.should_not be_able_to(:create, other_info)
      ability.should_not be_able_to(:update, other_info)
      ability.should_not be_able_to(:destroy, other_info)
    end

    it 'should not allow logged out users to see payment info' do
      ability = Ability.new(nil)
      ability.should_not be_able_to(:read, payment_info)
      ability.should_not be_able_to(:create, payment_info)
      ability.should_not be_able_to(:update, payment_info)
      ability.should_not be_able_to(:destroy, payment_info)
    end
  end


end
