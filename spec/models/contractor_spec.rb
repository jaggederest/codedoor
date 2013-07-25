require 'spec_helper'

describe Contractor do
  context 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_uniqueness_of(:user_id) }

    it { should ensure_length_of(:title).is_at_least(5).is_at_most(80) }

    it 'should allow integer rates between 20 and 500' do
      FactoryGirl.build(:contractor, rate: 20).should be_valid
      FactoryGirl.build(:contractor, rate: 500).should be_valid

      FactoryGirl.build(:contractor, rate: 19).should_not be_valid
      FactoryGirl.build(:contractor, rate: 501).should_not be_valid
      FactoryGirl.build(:contractor, rate: 20.5).should_not be_valid
      FactoryGirl.build(:contractor, rate: nil).should_not be_valid
    end

    it 'should only allow time_status to be "parttime" or "fulltime"' do
      FactoryGirl.build(:contractor, time_status: 'parttime').should be_valid
      FactoryGirl.build(:contractor, time_status: 'fulltime').should be_valid

      FactoryGirl.build(:contractor, time_status: nil).should_not be_valid
      FactoryGirl.build(:contractor, time_status: 'full time').should_not be_valid
    end

    it 'should only allow onsite_status to be "offsite", "occasional", or "onsite"' do
      FactoryGirl.build(:contractor, onsite_status: 'offsite').should be_valid
      FactoryGirl.build(:contractor, onsite_status: 'occasional').should be_valid
      FactoryGirl.build(:contractor, onsite_status: 'onsite').should be_valid

      FactoryGirl.build(:contractor, onsite_status: nil).should_not be_valid
      FactoryGirl.build(:contractor, onsite_status: 'on site').should_not be_valid
    end
  end

  context 'associations' do
    it { should belong_to(:user) }
  end

  context 'abilities' do
    let(:user) { FactoryGirl.create(:user) }
    let(:ability) { Ability.new(user) }

    it 'show allow a user to manage a Contractor that belongs to the user' do
      contractor = FactoryGirl.create(:contractor, user: user)
      ability.should be_able_to(:read, contractor)
      ability.should be_able_to(:create, contractor)
      ability.should be_able_to(:update, contractor)
      ability.should be_able_to(:destroy, contractor)
    end

    it 'should only allow a user to read a Contractor that belongs to someone else' do
      contractor = FactoryGirl.create(:contractor, user: FactoryGirl.create(:user))
      ability.should be_able_to(:read, contractor)
      ability.should_not be_able_to(:create, contractor)
      ability.should_not be_able_to(:update, contractor)
      ability.should_not be_able_to(:destroy, contractor)
    end

    it 'should only allow logged out users to view Contractors' do
      ability = Ability.new(nil)
      contractor = FactoryGirl.create(:contractor)
      ability.should be_able_to(:read, contractor)
      ability.should_not be_able_to(:create, contractor)
      ability.should_not be_able_to(:update, contractor)
      ability.should_not be_able_to(:destroy, contractor)
    end
  end

end
