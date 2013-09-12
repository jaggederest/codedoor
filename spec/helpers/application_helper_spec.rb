require 'spec_helper'

describe ApplicationHelper do

  describe 'model_error_message' do
    it 'return blank string if model\'s attribute is valid' do
      programmer = FactoryGirl.create(:programmer)
      model_error_message(programmer, :visibility).should eq('')
    end

    it 'returns a sentence if model\'s attribute is invalid' do
      programmer = FactoryGirl.create(:programmer)
      programmer.visibility = 'invalid'
      programmer.valid?
      model_error_message(programmer, :visibility).should eq('Visibility must be selected.')
    end

    it 'returns error messages from both validates and other validation methods' do
      resume_item = FactoryGirl.create(:resume_item)
      resume_item.year_started = 1801
      resume_item.year_finished = 1800
      resume_item.valid?
      model_error_message(resume_item, :year_started).should eq('Year started must be greater than 1900 and must be before the year finished.')
    end
  end
end
