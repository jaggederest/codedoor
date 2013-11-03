require 'spec_helper'

describe JobsController do

  before :each do
    @client = FactoryGirl.create(:client)
    @programmer = FactoryGirl.create(:programmer, :qualified)
    @empty_user = FactoryGirl.create(:user)
  end

  describe 'GET index' do
    before :each do
      @job = FactoryGirl.create(:job, client: @client, programmer: @programmer)
    end

    it 'should show jobs for client' do
      sign_in(@client.user)
      get :index
      assigns(:jobs_as_client).should eq([@job])
      assigns(:jobs_as_programmer).should eq([])
      response.should render_template('index')
    end

    it 'should show jobs for programmer' do
      sign_in(@programmer.user)
      get :index
      assigns(:jobs_as_programmer).should eq([@job])
      assigns(:jobs_as_client).should eq([])
      response.should render_template('index')
    end

    it 'should redirect if user does not have client or programmer' do
      sign_in(@empty_user)
      get :index
      response.should redirect_to(edit_user_path(@empty_user))
    end
  end

  describe 'GET new' do
    it 'should have a new job between the client and programmer' do
      sign_in(@client.user)
      get :new, programmer_id: @programmer.id
      assigns(:job).programmer.should eq(@programmer)
      assigns(:job).client.should eq(@client)
      response.should render_template('new')
    end

    it 'should not redirect if the previous job has been finished' do
      sign_in(@client.user)
      job = FactoryGirl.create(:job, client: @client, programmer: @programmer, state: 'finished')
      get :new, programmer_id: @programmer.id
      assigns(:job).programmer.should eq(@programmer)
      assigns(:job).client.should eq(@client)
      response.should render_template('new')
    end

    it 'should redirect if there is a current job between the client and freelancer' do
      sign_in(@client.user)
      job = FactoryGirl.create(:job, client: @client, programmer: @programmer, state: 'running')
      get :new, programmer_id: @programmer.id
      response.should redirect_to(edit_job_path(job.id))
    end

    it 'should redirect if you are not a client' do
      sign_in(@programmer.user)
      get :new, programmer_id: @programmer.id
      response.should redirect_to(new_user_client_path(@programmer.user))
    end
  end

  describe 'POST create' do
    it 'should redirect upon valid create' do
      sign_in(@client.user)
      post :create, job: {programmer_id: @programmer.id, name: 'Test job', job_messages_attributes: [{content: 'Test message'}]}
      response.should redirect_to(edit_job_path(Job.last.id))
      job = Job.last
      job.name.should eq('Test job')
      job.job_messages.first.content.should eq('Test message')
    end

    it 'should display proper message upon fail' do
      sign_in(@client.user)
      post :create, job: {programmer_id: @programmer.id, name: ''}
      response.should render_template('new')
      flash[:alert].should eq('Your message could not be sent.')
    end
  end

  describe 'GET edit' do
    it 'should assign @job and @programmer' do
      sign_in(@client.user)
      job = FactoryGirl.create(:job, client: @client, programmer: @programmer)
      get :edit, id: job.id
      response.should render_template('edit')
      assigns(:job).should eq(job)
      assigns(:programmer).should eq(@programmer)
    end

    it 'should have an error if the job is not associated with the client or programmer' do
      sign_in(@client.user)
      other_job = FactoryGirl.create(:job, client: FactoryGirl.create(:client), programmer: @programmer)
      get :edit, id: other_job.id
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end
  end

  describe 'POST create_message' do
    it 'should allow the client to add a message' do
      sign_in(@client.user)
      job = FactoryGirl.create(:job, client: @client, programmer: @programmer)
      post :create_message, id: job.id, job_message: {content: 'Test Message'}
      response.should redirect_to(edit_job_path(job))
      flash[:notice].should eq('Your message has been sent.')
      job.reload.job_messages.first.content.should eq('Test Message')
    end

    it 'should allow the programmer to add a message' do
      sign_in(@programmer.user)
      job = FactoryGirl.create(:job, client: @client, programmer: @programmer)
      post :create_message, id: job.id, job_message: {content: 'Test Message'}
      response.should redirect_to(edit_job_path(job))
      flash[:notice].should eq('Your message has been sent.')
      job.reload.job_messages.first.content.should eq('Test Message')
    end

    it 'should not allow anyone to add a blank message' do
      sign_in(@client.user)
      job = FactoryGirl.create(:job, client: @client, programmer: @programmer)
      post :create_message, id: job.id, job_message: {content: ''}
      response.should redirect_to(edit_job_path(job))
      flash[:alert].should eq('Your message could not be sent.')
      job.reload.job_messages.should eq([])
    end
  end

  describe 'POST offer' do
  end

  describe 'POST start' do
  end

  describe 'POST cancel' do
  end

  describe 'POST finish' do
  end

end
