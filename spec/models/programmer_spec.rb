require 'spec_helper'

describe Programmer do
  context 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_uniqueness_of(:user_id) }

    it { should ensure_length_of(:title).is_at_least(5).is_at_most(80) }

    it { ensure_inclusion_only_of(Programmer, :visibility, ['public', 'codedoor', 'private']) }

    it { ensure_inclusion_only_of(Programmer, :time_status, ['part-time', 'full-time']) }

    it { ensure_inclusion_only_of(Programmer, :onsite_status, ['offsite', 'occasional', 'visits_allowed', 'onsite'])}

    it 'should allow integer rates between 20 and 1000' do
      FactoryGirl.build(:programmer, rate: 20).should be_valid
      FactoryGirl.build(:programmer, rate: 1000).should be_valid

      FactoryGirl.build(:programmer, rate: 19).should_not be_valid
      FactoryGirl.build(:programmer, rate: 1001).should_not be_valid
      FactoryGirl.build(:programmer, rate: 20.5).should_not be_valid
      FactoryGirl.build(:programmer, rate: nil).should_not be_valid
    end

  end

  context 'associations' do
    it { should belong_to(:user) }
  end

  context 'abilities' do
    let(:user) { FactoryGirl.create(:user) }
    let(:ability) { Ability.new(user) }

    it 'show allow a user to manage a programmer that belongs to the user' do
      programmer = FactoryGirl.create(:programmer, user: user)
      ability.should be_able_to(:read, programmer)
      ability.should be_able_to(:create, programmer)
      ability.should be_able_to(:update, programmer)
      ability.should be_able_to(:destroy, programmer)
    end

    it 'should only allow a user to read a programmer that belongs to someone else' do
      programmer = FactoryGirl.create(:programmer, user: FactoryGirl.create(:user))
      ability.should be_able_to(:read, programmer)
      ability.should_not be_able_to(:create, programmer)
      ability.should_not be_able_to(:update, programmer)
      ability.should_not be_able_to(:destroy, programmer)
    end

    it 'should only allow logged out users to view programmers' do
      ability = Ability.new(nil)
      programmer = FactoryGirl.create(:programmer)
      ability.should be_able_to(:read, programmer)
      ability.should_not be_able_to(:create, programmer)
      ability.should_not be_able_to(:update, programmer)
      ability.should_not be_able_to(:destroy, programmer)
    end
  end

  context 'rates' do
    before :each do
      @programmer = FactoryGirl.create(:programmer, rate: 50)
    end

    it 'should return the correct daily rate for the programmer' do
      expect(@programmer.daily_rate_to_programmer).to eq(@programmer.rate * 8)
    end
    it 'should return the correct daily rate for the client' do
      expect(@programmer.daily_rate_to_client).to eq(@programmer.rate * 9)
    end
  end

  context 'onsite status description' do
    it 'should return correct status descriptions for each status type' do
      expect(Programmer.onsite_status_description(:onsite)).to eq('Work can be done at a client\'s office if it is nearby.')
      expect(Programmer.onsite_status_description(:occasional)).to eq('Work can occasionally be done at a client\'s office if it is nearby.')
      expect(Programmer.onsite_status_description(:visits_allowed)).to eq('Clients can visit the programmer\'s office if they wish.')
      expect(Programmer.onsite_status_description(:offsite)).to eq('All work is to be done remotely.')
    end

    it 'should work for strings as well as symbols' do
      expect(Programmer.onsite_status_description('onsite')).to eq('Work can be done at a client\'s office if it is nearby.')
      expect(Programmer.onsite_status_description('occasional')).to eq('Work can occasionally be done at a client\'s office if it is nearby.')
      expect(Programmer.onsite_status_description('visits_allowed')).to eq('Clients can visit the programmer\'s office if they wish.')
      expect(Programmer.onsite_status_description('offsite')).to eq('All work is to be done remotely.')
    end

    it 'should throw an error for any other parameter' do
      expect { programmer.onsite_status_description(nil) }.to raise_error
      expect { programmer.onsite_status_description(:other) }.to raise_error
    end
  end

end
