require 'spec_helper'

describe Job do
  context 'validations' do
    it { should validate_presence_of(:client_id) }
    it { should validate_presence_of(:programmer_id) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:rate) }

    it 'should validate client_and_programmer_are_different' do
      user = FactoryGirl.create(:user)
      job = FactoryGirl.create(:job)
      job.valid?.should be_true
      job.programmer = FactoryGirl.create(:programmer, user: user)
      job.client = FactoryGirl.create(:client, user: user)
      job.valid?.should be_false
      job.errors[:programmer].should eq(['must refer to a different user'])
    end

    it 'should validate rate_is_unchanged if the job is running' do
      job = FactoryGirl.create(:job, rate: 55, state: 'running')
      job.valid?.should be_true
      job.rate = 66
      job.valid?.should be_false
      job.errors[:rate].should eq(['must stay the same for the job'])
    end

    it 'should allow rate to change if the job is not running' do
      job = FactoryGirl.create(:job, rate: 55, state: 'offered')
      job.valid?.should be_true
      job.rate = 66
      job.valid?.should be_true
    end
  end

  context 'is_client?' do
    it 'should return true if it is the client' do
      job = FactoryGirl.create(:job)
      job.is_client?(job.client.user).should be_true
    end

    it 'should return false if it is not the client' do
      job = FactoryGirl.create(:job)
      job.is_client?(job.programmer.user).should be_false
    end

    it 'should throw an error if the parameter is not a user' do
      job = FactoryGirl.create(:job)
      -> { job.is_client?(job.client) }.should raise_error
    end
  end
end
