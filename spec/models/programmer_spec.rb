require 'spec_helper'

describe Programmer do
  context 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_uniqueness_of(:user_id) }

    it { should ensure_length_of(:title).is_at_least(5).is_at_most(80) }

    it { ensure_inclusion_only_of(Programmer, :visibility, ['public', 'codedoor', 'private']) }

    it { ensure_inclusion_only_of(Programmer, :availability, ['part-time', 'full-time', 'unavailable']) }

    it { ensure_inclusion_only_of(Programmer, :onsite_status, ['offsite', 'occasional', 'visits_allowed', 'onsite'])}

    it 'should allow integer rates between 20 and 1000' do
      FactoryGirl.build(:programmer, rate: 20).should be_valid
      FactoryGirl.build(:programmer, rate: 1000).should be_valid

      FactoryGirl.build(:programmer, rate: 19).should_not be_valid
      FactoryGirl.build(:programmer, rate: 1001).should_not be_valid
      FactoryGirl.build(:programmer, rate: 20.5).should_not be_valid
      FactoryGirl.build(:programmer, rate: nil).should_not be_valid
    end

    it 'should require at least one skill' do
      FactoryGirl.build(:programmer, skills: [Skill.find_by_name('C++')]).should be_valid
      FactoryGirl.build(:programmer, skills: []).should_not be_valid
    end

  end

  context 'associations' do
    it { should belong_to(:user) }
  end

  context 'state_machine' do
    it 'should activate on update' do
      programmer = FactoryGirl.create(:programmer, state: :incomplete)
      # TODO: Ideally, this is not necessary...
      programmer.reload
      programmer.save!
      programmer.activated?.should be_true
    end

    it 'should not activate on update if the model is not valid' do
      programmer = FactoryGirl.create(:programmer, state: :incomplete)
      programmer.reload
      programmer.title = ''
      programmer.save(validate: false)
      programmer.activated?.should be_false
    end

    it 'should get disabled' do
      programmer = FactoryGirl.create(:programmer)
      programmer.disable!
      programmer.disabled?.should be_true
    end

  end

  context 'abilities' do
    let(:user) { FactoryGirl.create(:user) }
    let(:ability) { Ability.new(user) }

    it 'show allow a user to manage a programmer that belongs to the user' do
      programmer = FactoryGirl.create(:programmer, user: user, visibility: 'private')
      ability.should be_able_to(:read, programmer)
      ability.should be_able_to(:create, programmer)
      ability.should be_able_to(:update, programmer)
      ability.should be_able_to(:destroy, programmer)
    end

    it 'should only allow a user to read a non-private programmer that belongs to someone else' do
      programmer = FactoryGirl.create(:programmer, user: FactoryGirl.create(:user), visibility: 'codedoor', state: 'activated', qualified: true)
      private_programmer = FactoryGirl.create(:programmer, user: FactoryGirl.create(:user), visibility: 'private', qualified: true)
      unactivated_programmer = FactoryGirl.create(:programmer, user: FactoryGirl.create(:user), visibility: 'codedoor', state: 'incomplete')
      unqualified_programmer = FactoryGirl.create(:programmer, user: FactoryGirl.create(:user), visibility: 'codedoor', state: 'activated', qualified: false)
      ability.should be_able_to(:read, programmer)
      ability.should_not be_able_to(:read, private_programmer)
      ability.should_not be_able_to(:read, unactivated_programmer)
      ability.should_not be_able_to(:read, unqualified_programmer)
      ability.should_not be_able_to(:create, programmer)
      ability.should_not be_able_to(:update, programmer)
      ability.should_not be_able_to(:destroy, programmer)
    end

    it 'should allow logged out users to only view public programmers' do
      ability = Ability.new(nil)
      programmer = FactoryGirl.create(:programmer, visibility: 'codedoor')
      public_programmer = FactoryGirl.create(:programmer, visibility: 'public')
      ability.should be_able_to(:read, public_programmer)
      ability.should_not be_able_to(:read, programmer)
      ability.should_not be_able_to(:create, programmer)
      ability.should_not be_able_to(:update, programmer)
      ability.should_not be_able_to(:destroy, programmer)
    end
  end

  context 'rates' do
    before :each do
      @programmer = FactoryGirl.create(:programmer, rate: 51)
    end

    it 'should return the correct daily rate for the programmer' do
      @programmer.daily_rate_to_programmer.should eq(@programmer.rate * 8)
    end

    it 'should return the correct daily rate for the client' do
      @programmer.daily_rate_to_client.should eq(@programmer.rate * 9)
    end

    it 'should return the correct daily fee for CodeDoor' do
      @programmer.daily_fee_to_codedoor.should eq(@programmer.rate)
    end

    it 'should return the correct hourly rate for the client' do
      @programmer.hourly_rate_to_client.should eq(57.38)
    end

    it 'should return the correct hourly fee for CodeDoor' do
      @programmer.hourly_fee_to_codedoor.should eq(6.38)
    end

    it 'should convert a client\'s rate to the internal programmer rate' do
      Programmer.client_rate_to_programmer_rate(113).should eq(100.44)
    end

    it 'should return nil when rate is nil' do
      new_programmer = Programmer.new(rate: nil)

      new_programmer.daily_rate_to_programmer.should be_nil
      new_programmer.daily_rate_to_client.should be_nil
      new_programmer.daily_fee_to_codedoor.should be_nil
      new_programmer.hourly_rate_to_client.should be_nil
      new_programmer.hourly_fee_to_codedoor.should be_nil
    end
  end

  context 'onsite status description' do
    it 'should return correct status descriptions for each status type' do
      Programmer.onsite_status_description(:onsite).should eq('Work can be done at a client\'s office if it is nearby.')
      Programmer.onsite_status_description(:occasional).should eq('Work can occasionally be done at a client\'s office if it is nearby.')
      Programmer.onsite_status_description(:visits_allowed).should eq('Clients can visit the programmer\'s office if they wish.')
      Programmer.onsite_status_description(:offsite).should eq('All work is to be done remotely.')
    end

    it 'should work for strings as well as symbols' do
      Programmer.onsite_status_description('onsite').should eq('Work can be done at a client\'s office if it is nearby.')
      Programmer.onsite_status_description('occasional').should eq('Work can occasionally be done at a client\'s office if it is nearby.')
      Programmer.onsite_status_description('visits_allowed').should eq('Clients can visit the programmer\'s office if they wish.')
      Programmer.onsite_status_description('offsite').should eq('All work is to be done remotely.')
    end

    it 'should throw an error for any other parameter' do
      -> { Programmer.onsite_status_description(nil) }.should raise_error
      -> { Programmer.onsite_status_description(:other) }.should raise_error
    end
  end

  context 'client_rate_text' do
    it 'should show rate for full-time programmers' do
      programmer = FactoryGirl.create(:programmer, availability: 'full-time', rate: 50)
      programmer.client_rate_text.should eq('$450 / day')
    end
    it 'should show rate for part-time programmers' do
      programmer = FactoryGirl.create(:programmer, availability: 'part-time', rate: 50)
      programmer.client_rate_text.should eq('$450 / 8 hours')
    end
    it 'should not show rate for unavailable programmers' do
      programmer = FactoryGirl.create(:programmer, availability: 'unavailable', rate: 50)
      programmer.client_rate_text.should eq('Unavailable')
    end
  end

end
