require 'spec_helper'

describe Contractor do
  context 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_uniqueness_of(:user_id) }

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
  end

  context 'associations' do
    it { should belong_to(:user) }
  end
end
