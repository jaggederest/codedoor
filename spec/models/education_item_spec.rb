require 'spec_helper'

describe EducationItem do
  context 'validations' do
    it { should validate_presence_of(:school_name) }
    it { should validate_numericality_of(:month_started).is_greater_than_or_equal_to(1).is_less_than_or_equal_to(12) }
    it { should validate_numericality_of(:month_finished).is_greater_than_or_equal_to(1).is_less_than_or_equal_to(12) }

    it { should validate_numericality_of(:year_started).is_greater_than_or_equal_to(1900).is_less_than_or_equal_to(2014) }
    it { should validate_numericality_of(:year_finished).is_greater_than_or_equal_to(1900).is_less_than_or_equal_to(2014) }
  end

  context 'dates' do
    it 'should allow year_started and a year_finished that is a later year' do
      FactoryGirl.build(:education_item, month_started: 1, month_finished: 1, year_started: 1990, year_finished: 1999).should be_valid
    end

    it 'should allow starting and finishing on the same month' do
      FactoryGirl.build(:education_item, month_started: 1, month_finished: 1, year_started: 1999, year_finished: 1999).should be_valid
    end

    it 'should not allow the finish month to come first if the years are the same' do
      FactoryGirl.build(:education_item, month_started: 2, month_finished: 1, year_started: 1999, year_finished: 1999).should_not be_valid
    end

    it 'should allow no year_finished if it is current' do
      FactoryGirl.build(:education_item, year_finished: nil, is_current: true).should be_valid
    end

    it 'should not allow having no year_finished if it is not current' do
      FactoryGirl.build(:education_item, year_finished: nil, is_current: false).should_not be_valid
    end

    it 'should allow no month_finished if it is current' do
      FactoryGirl.build(:education_item, month_finished: nil, is_current: true).should be_valid
    end

    it 'should not allow having no month_finished if it is not current' do
      FactoryGirl.build(:education_item, month_finished: nil, is_current: false).should_not be_valid
    end

    it 'should not allow year_started to be nil' do
      FactoryGirl.build(:education_item, year_started: nil, year_finished: 2012).should_not be_valid
    end

    it 'should not allow a year_finished that comes before a year_started' do
      FactoryGirl.build(:education_item, year_started: 2013, year_finished: 2012).should_not be_valid
    end
  end

  context 'associations' do
    it { should belong_to(:programmer) }
  end

  context 'hooks' do
    it 'should remove month_finished and year_finished if it is current' do
      edu = FactoryGirl.create(:education_item, month_finished: 1, year_finished: 2012, is_current: true)
      edu.month_finished.should be_nil
      edu.year_finished.should be_nil
    end
  end

  context 'abilities' do
    it 'should have the permissions of a programmer resume item' do
      validate_ability_of_programmer_resume_item(:education_item)
    end
  end

end