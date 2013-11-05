require "spec_helper"

describe UserMailer do
  let(:user) { mock_model(User, full_name: 'John Smith', email: 'john-smith@example.com') }

  describe 'welcome_email' do
    let(:mail) { UserMailer.welcome_email(user) }

    it 'renders the subject' do
      mail.subject.should eq('Welcome to CodeDoor')
    end

    it 'renders the receiver email' do
      mail.to.should eq([user.email])
    end

    it 'renders the sender email' do
      mail.from.should eq(['rcheng@codedoor.com'])
    end

    it 'renders the body' do
      mail.body.encoded.should match('Dear John Smith,')
      mail.body.encoded.should match('Welcome to CodeDoor, the marketplace for programmers that have contributed to open source.')
      mail.body.encoded.should match('If you have any questions, feel free to give an email to rcheng@codedoor.com.')
      mail.body.encoded.should match('-The CodeDoor Team')
    end
  end

  describe 'message_sent' do
    let(:job) { mock_model(Job, id: 123) }
    let(:message) { mock_model(JobMessage, content: 'Test Content') }
    let(:other_user) { mock_model(User, full_name: 'Other User', email: 'other-user@example.com') }
    let(:mail) { UserMailer.message_sent(user, job, message, other_user) }

    it 'renders the subject' do
      mail.subject.should eq('Message from Other User')
    end

    it 'renders the receiver email' do
      mail.to.should eq([user.email])
    end

    it 'renders the sender email' do
      mail.from.should eq(['rcheng@codedoor.com'])
    end

    it 'renders the body' do
      mail.body.encoded.should match('Dear John Smith,')
      mail.body.encoded.should match('Other User has sent you a message:')
      mail.body.encoded.should match('Test Content')
      mail.body.encoded.should match('To reply to Other User, visit https://www.codedoor.com/jobs/123/edit')
      mail.body.encoded.should match('-The CodeDoor Team')
    end
  end

  describe 'state_occurred_to_job' do
    let(:job) { mock_model(Job, id: 123) }
    let(:other_user) { mock_model(User, full_name: 'Other User', email: 'other-user@example.com') }
    let(:mail) { UserMailer.state_occurred_to_job(user, job, other_user, :action_name) }

    it 'renders the subject' do
      mail.subject.should eq('Job has been action_name')
    end

    it 'renders the receiver email' do
      mail.to.should eq([user.email])
    end

    it 'renders the sender email' do
      mail.from.should eq(['rcheng@codedoor.com'])
    end

    it 'renders the body' do
      mail.body.encoded.should match('Dear John Smith,')
      mail.body.encoded.should match('A job between you and Other User has been action_name.')
      mail.body.encoded.should match('To see more information, visit https://www.codedoor.com/jobs/123/edit')
      mail.body.encoded.should match('-The CodeDoor Team')
    end
  end


end
