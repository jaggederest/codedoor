class JobsController < ApplicationController
  before_filter :client_or_programmer_required, only: [:index, :edit, :create_message, :finish]
  before_filter :client_required, only: [:new, :create, :offer, :cancel]
  before_filter :programmer_required, only: [:start, :decline]

  load_and_authorize_resource except: [:create, :create_message, :offer, :start, :cancel, :decline, :finish]

  def index
    @jobs_as_client = current_user.client.present? ? Job.where(client_id: current_user.client.id) : []
    @jobs_as_programmer = current_user.completed_programmer_account? ? Job.where(programmer_id: current_user.programmer.id) : []
  end

  def new
    @programmer = Programmer.find(params[:programmer_id])

    redirect_cannot_be_found if @programmer.unavailable?
    existing_jobs = Job.where('programmer_id = ? AND client_id = ? AND (state = ? OR state = ? OR state = ?)', @programmer.id, current_user.client.id, 'has_not_started', 'offered', 'running')
    redirect_to edit_job_path(existing_jobs.first) unless existing_jobs.empty?

    @job = Job.new(client_id: current_user.client.id, programmer_id: @programmer.id, rate: @programmer.rate, availability: @programmer.availability)
  end

  def create
    @job = Job.new(create_job_params)
    @programmer = @job.programmer
    redirect_cannot_be_found if @programmer.unavailable?

    @job.client_id = current_user.client.id
    @job.rate = @programmer.rate
    @job.availability = @programmer.availability
    authorize! :create, @job
    if @job.save
      flash[:notice] = 'Your message has been sent.'
      redirect_to edit_job_path(@job)
    else
      flash[:alert] = 'Your message could not be sent.'
      render :new
    end
  end

  def edit
    @programmer = @job.programmer
  end

  def create_message
    @job = Job.find(params[:id])
    authorize! :update, @job
    @programmer = @job.programmer
    @job_message = JobMessage.new(create_message_params)
    @job_message.job = @job
    @job_message.sender_is_client = @job.is_client?(current_user)
    if @job_message.save
      UserMailer.message_sent(@job.other_user(current_user), @job, @job_message, current_user).deliver
      flash[:notice] = 'Your message has been sent.'
    else
      flash[:alert] = 'Your message could not be sent.'
    end
    redirect_to action: :edit
  end

  def offer
    # The rate and availability gets locked at the time of offer
    state_change(:update_as_client, ->{@job.has_not_started?}, ->{@job.availability = @job.programmer.availability; @job.rate = @job.programmer.rate; @job.offer!}, :offered, 'The job has been offered.', 'The job could not be offered.')
  end

  def cancel
    state_change(:update_as_client, ->{@job.offered?}, ->{@job.cancel!}, :canceled, 'The job has been canceled.', 'The job could not be canceled.')
  end

  def start
    state_change(:update_as_programmer, ->{@job.offered?}, ->{@job.start!}, :started, 'The job has been started.', 'The job could not be started.')
  end

  def decline
    state_change(:update_as_programmer, ->{@job.offered?}, ->{@job.decline!}, :declined, 'The job has been declined.', 'The job could not be declined.')
  end

  def finish
    state_change(:update, ->{@job.offered? || @job.running?}, ->{@job.finish!}, :finished, 'The job is now finished.', 'The job could not be finished.')
  end

  private

  def state_change(permission_required, state_required, action, action_name, success_message, failure_message)
    @job = Job.find(params[:id])
    authorize! permission_required, @job
    if state_required.call
      action.call
      UserMailer.state_occurred_to_job(@job.other_user(current_user), @job, current_user, action_name).deliver
      flash[:notice] = success_message
    else
      flash[:alert] = failure_message
    end
    redirect_to action: :edit
  end

  def create_job_params
    params.require(:job).permit(:programmer_id, :name, job_messages_attributes: [:content])
  end

  def create_message_params
    params.require(:job_message).permit(:content)
  end

end
