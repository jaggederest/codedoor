class UserMailer < ActionMailer::Base
  # rhc2104: If I get spammed, it's a great problem to have, I guess...
  default from: 'rcheng@codedoor.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to CodeDoor')
  end

  def message_sent(user, job, message, other_user)
    @user = user
    @job = job
    @message = message
    @other_user = other_user
    mail(to: @user.email, subject: "Message from #{@other_user.full_name}")
  end

  def state_occurred_to_job(user, job, other_user, action_name)
    @user = user
    @job = job
    @other_user = other_user
    @action_name = action_name
    mail(to: @user.email, subject: "Job has been #{action_name.to_s}")
  end

end
