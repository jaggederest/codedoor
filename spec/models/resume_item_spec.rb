require 'spec_helper'

describe ResumeItem do
  context 'validations' do
    it { should validate_uniqueness_of(:programmer_id) }
    it { should validate_presence_of(:company_name) }
    it { should validate_numericality_of(:year_started) }
    it { should validate_numericality_of(:year_finished) }
    it 'should validate month_started' do
      ensure_inclusion_only_of(ResumeItem, :month_started, ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'])
      FactoryGirl.build(:resume_item, month_started: nil).should be_valid
    end
    it 'should validate month_finished' do
      ensure_inclusion_only_of(ResumeItem, :month_finished, ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'])
      FactoryGirl.build(:resume_item, month_finished: nil).should be_valid
    end
  end

  context 'year_started and year_finished' do
    it 'should allow year_started and a year_finished that is a later year' do
      FactoryGirl.build(:resume_item, year_started: 1990, year_finished: 1999).should be_valid
    end

    it 'should allow year_started and a year_finished that is the same year' do
      FactoryGirl.build(:resume_item, year_started: 1999, year_finished: 1999).should be_valid
    end

    it 'should allow year_started and no year_finished' do
      FactoryGirl.build(:resume_item, year_started: 1990, year_finished: nil).should be_valid
    end

    it 'should allow year_started to be 2013 and year_finished to be 2013' do
      FactoryGirl.build(:resume_item, year_started: 2013, year_finished: 2013).should be_valid
    end

    it 'should not allow year_started to be nil' do
      FactoryGirl.build(:resume_item, year_started: nil, year_finished: 2012).should_not be_valid
    end

    it 'should not allow a year_finished that comes before a year_started' do
      FactoryGirl.build(:resume_item, year_started: 2013, year_finished: 2012).should_not be_valid
    end

    it 'should not allow year_started to be 1900' do
      FactoryGirl.build(:resume_item, year_started: 1900, year_finished: 1999).should_not be_valid
    end

    it 'should not allow year_finished to be 1900' do
      FactoryGirl.build(:resume_item, year_started: 1900, year_finished: 1900).should_not be_valid
    end

    it 'should not allow year_started to be 2014' do
      FactoryGirl.build(:resume_item, year_started: 2014, year_finished: 2014).should_not be_valid
    end

    it 'should not allow year_finished to be 2014' do
      FactoryGirl.build(:resume_item, year_started: 2012, year_finished: 2014).should_not be_valid
    end

  end

  context 'associations' do
    it { should belong_to(:programmer) }
  end

  context 'abilities' do
    let(:user) { FactoryGirl.create(:user) }
    let(:programmer) { FactoryGirl.create(:programmer, user: user) }
    let(:ability) { Ability.new(user) }

    it 'should allow users to manage their own resume items' do
      resume_item = FactoryGirl.create(:resume_item, programmer: programmer)
      ability.should be_able_to(:read, resume_item)
      ability.should be_able_to(:create, resume_item)
      ability.should be_able_to(:update, resume_item)
      ability.should be_able_to(:destroy, resume_item)
    end

    it 'should allow users to only view other people\'s resume items' do
      resume_item = FactoryGirl.create(:resume_item, programmer: FactoryGirl.create(:programmer))
      ability.should be_able_to(:read, resume_item)
      ability.should_not be_able_to(:create, resume_item)
      ability.should_not be_able_to(:update, resume_item)
      ability.should_not be_able_to(:destroy, resume_item)
    end

    it 'should allow logged out users to only view resume items' do
      ability = Ability.new(nil)
      resume_item = FactoryGirl.create(:resume_item)
      ability.should be_able_to(:read, resume_item)
      ability.should_not be_able_to(:create, resume_item)
      ability.should_not be_able_to(:update, resume_item)
      ability.should_not be_able_to(:destroy, resume_item)
    end

  end

end