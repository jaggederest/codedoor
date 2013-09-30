require 'spec_helper'

describe PaymentInfo do
  context 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_uniqueness_of(:user_id) }
  end

  context 'associations' do
    it { should belong_to(:user) }
  end

  context 'calling balanced api' do
    before :each do
      @payment_info = FactoryGirl.create(:payment_info)
      @payment_info_with_uri = FactoryGirl.create(:payment_info, balanced_customer_uri: 'TESTVALUE')
    end

    context 'get_cards' do
      it 'should not call balanced_customer if there is no uri' do
        @payment_info.should_not_receive(:balanced_customer)
        cards = @payment_info.get_cards
        cards.should eq([])
      end

      it 'should call balanced_customer if there is a uri' do
        @payment_info_with_uri.should_receive(:balanced_customer).exactly(1).times.and_return(double(cards: []))
        @payment_info_with_uri.get_cards
      end
    end

    context 'associate_card' do
      it 'should call balanced_customer if there is no uri' do
        @payment_info.should_receive(:balanced_customer).exactly(1).times.and_return(double(add_card: nil))
        @payment_info.associate_card('TESTVALUE')
      end

      it 'should call balanced_customer if there is a uri' do
        @payment_info_with_uri.should_receive(:balanced_customer).exactly(1).times.and_return(double(add_card: nil))
        @payment_info_with_uri.associate_card('TESTVALUE')
      end
    end

    context 'charge_card' do
      it 'should raise error if there is no uri' do
        -> { @payment_info.charge_card(2000) }.should raise_error
      end

      it 'should call balanced_customer if there is a uri' do
        @payment_info_with_uri.should_receive(:balanced_customer).exactly(1).times.and_return(double(debit: nil))
        @payment_info_with_uri.charge_card(2000)
      end
    end
  end

  context 'abilities' do
    let(:user) { FactoryGirl.create(:user) }
    let(:payment_info) { FactoryGirl.create(:payment_info, user: user) }
    let(:other_payment_info) { FactoryGirl.create(:payment_info, user: FactoryGirl.create(:user)) }
    let(:ability) { Ability.new(user) }

    it 'should allow a user to manage his or her own payment info' do
      ability.should be_able_to(:read,    payment_info)
      ability.should be_able_to(:create,  payment_info)
      ability.should be_able_to(:update,  payment_info)
      ability.should be_able_to(:destroy, payment_info)
    end

    it 'should not allow a user to do anything about other users\' payment into' do
      ability.should_not be_able_to(:read,    other_payment_info)
      ability.should_not be_able_to(:create,  other_payment_info)
      ability.should_not be_able_to(:update,  other_payment_info)
      ability.should_not be_able_to(:destroy, other_payment_info)
    end

    it 'should not allow logged out users to see any payment info' do
      ability = Ability.new(nil)
      ability.should_not be_able_to(:read,    payment_info)
      ability.should_not be_able_to(:create,  payment_info)
      ability.should_not be_able_to(:update,  payment_info)
      ability.should_not be_able_to(:destroy, payment_info)
    end
  end

end
