require 'spec_helper'

describe JobMessage do
  context 'validations' do
    it { should validate_presence_of(:content) }
  end

  context 'sender_name' do
    before :each do
      @job = FactoryGirl.create(:job, programmer: FactoryGirl.create(:programmer, user: FactoryGirl.create(:user, full_name: 'Programmer')), client: FactoryGirl.create(:client, user: FactoryGirl.create(:user, full_name: 'Client')))
    end

    it 'should be client name if client sent it' do
      job_message = FactoryGirl.create(:job_message, job: @job, sender_is_client: true)
      job_message.sender_name.should eq('Client')
    end

    it 'should be programmer name if programmer sent it' do
      job_message = FactoryGirl.create(:job_message, job: @job, sender_is_client: false)
      job_message.sender_name.should eq('Programmer')
    end
  end

  context 'created_at_text' do
    it 'should return text' do
      job_message = FactoryGirl.create(:job_message)
      job_message.created_at = Time.parse('2008-06-21 13:30:00 UTC')
      job_message.created_at_text.should eq('June 21')
    end
  end

end
