class JobsController < ApplicationController
  before_filter :client_or_programmer_required, only: [:index, :edit, :create_message, :finish]
  before_filter :client_required, only: [:new, :create, :offer]
  before_filter :programmer_required, only: [:start]

  load_and_authorize_resource except: [:create, :offer, :start, :finish]

  def index
    @jobs_as_client = current_user.client.present? ? Job.where(client_id: current_user.client.id) : []
    @jobs_as_programmer = current_user.programmer.present? ? Job.where(programmer_id: current_user.programmer.id) : []
  end

  def new
    @programmer = Programmer.find(params[:programmer_id])
    existing_jobs = Job.where('programmer_id = ? AND client_id = ? AND (state = ? OR state = ? OR state = ?)', @programmer.id, current_user.client.id, 'has_not_started', 'offered', 'running')
    redirect_to edit_job_path(existing_jobs.first) unless existing_jobs.empty?

    @job = Job.new(client_id: current_user.client.id, programmer_id: @programmer.id)
  end

  def create
    @job = Job.new(create_job_params)
    @programmer = @job.programmer

    @job.client_id = current_user.client.id
    @job.rate = @programmer.rate
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
    authorize! :update, @job
    @programmer = @job.programmer
    @job_message = JobMessage.new(create_message_params)
    @job_message.job = @job
    @job_message.sender_is_client = @job.is_client?(current_user)
    if @job_message.save
      flash[:notice] = 'Your message has been sent.'
    else
      flash[:alert] = 'Your message could not be sent.'
    end
    render :edit
  end

  def offer
    @job = Job.find(params[:id])
    authorize! :update_as_programmer, @job
    if @job.has_not_started?
      # The rate gets locked at the time of offer
      @job.rate = @job.programmer.rate
      @job.offer!
      flash[:notice] = 'The job has been offered.'
    else
      flash[:alert] = 'The job could not be offered.'
    end
  end

  def start
    @job = Job.find(params[:id])
    authorize! :update_as_client, @job
    if @job.offered?
      @job.start!
      flash[:notice] = 'The job has been started.'
    else
      flash[:alert] = 'The job could not be started.'
    end
    redirect_to action: :edit
  end

  def finish
    @job = Job.find(params[:id])
    authorize! :update, @job
    if @job.offered? || @job.running?
      @job.finish!
      flash[:notice] = 'The job is finished.'
    else
      flash[:alert] = 'The job could not be finished.'
    end
    redirect_to action: :edit
  end

  private

  def create_job_params
    params.require(:job).permit(:programmer_id, :name, job_messages_attributes: [:content])
  end

  def create_message_params
    params.require(:job_message).permit(:content)
  end

end
