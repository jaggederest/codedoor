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

    it 'should allow rate to change if the job has not been offered' do
      job = FactoryGirl.create(:job, rate: 55, state: 'has_not_started')
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

  context 'state_machine' do
    it 'should allow offer if has_not_started' do
      job = FactoryGirl.create(:job, state: 'has_not_started')
      job.offer!
      job.offered?.should be_true

      job = FactoryGirl.create(:job, state: 'running')
      -> {job.offer!}.should raise_error
    end

    it 'should allow start if offered' do
      job = FactoryGirl.create(:job, state: 'offered')
      job.start!
      job.running?.should be_true

      job = FactoryGirl.create(:job, state: 'running')
      -> {job.start!}.should raise_error
    end

    it 'should allow cancel if offered' do
      job = FactoryGirl.create(:job, state: 'offered')
      job.cancel!
      job.canceled?.should be_true

      job = FactoryGirl.create(:job, state: 'running')
      -> {job.cancel!}.should raise_error
    end

    it 'should allow decline if offered' do
      job = FactoryGirl.create(:job, state: 'offered')
      job.decline!
      job.declined?.should be_true

      job = FactoryGirl.create(:job, state: 'running')
      -> {job.decline!}.should raise_error
    end

    it 'should allow finish if offered or running' do
      job = FactoryGirl.create(:job, state: 'offered')
      job.finish!
      job.finished?.should be_true

      job = FactoryGirl.create(:job, state: 'running')
      job.finish!
      job.finished?.should be_true

      job = FactoryGirl.create(:job, state: 'has_not_started')
      -> {job.finish!}.should raise_error
    end

    it 'should always allow disable' do
      job = FactoryGirl.create(:job, state: 'has_not_started')
      job.disable!
      job.disabled?.should be_true

      job = FactoryGirl.create(:job, state: 'offered')
      job.disable!
      job.disabled?.should be_true

      job = FactoryGirl.create(:job, state: 'running')
      job.disable!
      job.disabled?.should be_true
    end
  end

  context 'abilities' do
    let(:user) { FactoryGirl.create(:user) }
    let(:client) { FactoryGirl.create(:client, user: user) }
    let(:programmer) { FactoryGirl.create(:programmer, user: user) }
    let(:ability) { Ability.new(user) }

    it 'should be able to create and update as client' do
      job = FactoryGirl.create(:job, client: client)
      ability.should be_able_to(:create, job)
      ability.should be_able_to(:read, job)
      ability.should be_able_to(:update, job)
      ability.should be_able_to(:destroy, job)
      ability.should be_able_to(:update_as_client, job)

      ability.should_not be_able_to(:update_as_programmer, job)
    end

    it 'should be able to create and update as programmer' do
      job = FactoryGirl.create(:job, programmer: programmer)
      ability.should be_able_to(:read, job)
      ability.should be_able_to(:update, job)
      ability.should be_able_to(:destroy, job)
      ability.should be_able_to(:update_as_programmer, job)

      ability.should_not be_able_to(:create, job)
      ability.should_not be_able_to(:update_as_client, job)
    end

    it 'should not be able to do anything if neither client nor programmer' do
      job = FactoryGirl.create(:job)
      ability.should_not be_able_to(:create, job)
      ability.should_not be_able_to(:read, job)
      ability.should_not be_able_to(:update, job)
      ability.should_not be_able_to(:destroy, job)
      ability.should_not be_able_to(:update_as_client, job)
      ability.should_not be_able_to(:update_as_programmer, job)
    end

  end
end
