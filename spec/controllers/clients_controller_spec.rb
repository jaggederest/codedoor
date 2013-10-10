require 'spec_helper'

describe ClientsController do
  before :each do
    @user = FactoryGirl.create(:user, checked_terms: true, country: 'CA', city: 'Vancouver')
    sign_in(@user)
  end

  describe 'GET new' do
    it 'should assign @client and render view' do
      get :new, user_id: @user.id
      assigns(:client).user_id.should eq(@user.id)
      response.should render_template('new')
    end

    it 'should redirect to edit if client exists' do
      FactoryGirl.create(:client, user: @user)
      get :new, user_id: @user.id
      response.should redirect_to(action: :edit)
    end

    it 'should fail when the user has not checked terms' do
      @user.checked_terms = false
      @user.save(validate: false)
      get :new, user_id: @user.id
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end
  end

  describe 'POST create' do
    it 'should ignore the user_id parameter and create the client' do
      post :create, user_id: @user.id, client: {user_id: 'ignore', company: 'Test Company', description: 'Test Company Description'}
      response.should render_template('edit')
      client = Client.find_by_user_id(@user.id)
      flash[:notice].should eq('Your client account has been created.')
      client.user_id.should eq(@user.id)
      client.company.should eq('Test Company')
      client.description.should eq('Test Company Description')
    end

    it 'should fail create if the parameters passed in are invalid' do
      post :create, user_id: @user.id, client: {company: 's'}
      response.should render_template('new')
      flash[:alert].should eq('Your client account could not be created.')
      assigns(:client).errors[:company].should eq(['is too short (minimum is 2 characters)'])
      assigns(:client).company.should eq('s')
    end
  end

  describe 'GET edit' do
    before :each do
      @client = FactoryGirl.create(:client, user: @user, company: 'Test Company')
    end

    it 'should assign @client and render view' do
      get :edit, user_id: @user.id
      assigns(:client).user_id.should eq(@user.id)
      response.should render_template('edit')
    end

    it 'should fail when the user has not checked terms' do
      @user.checked_terms = false
      @user.save(validate: false)
      get :edit, user_id: @user.id
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end
  end

  describe 'POST update' do
    before :each do
      @client = FactoryGirl.create(:client, user: @user, company: 'Test Company')
    end

    it 'should ignore the user_id parameter and update the client' do
      post :update, user_id: @user.id, id: @client.id, client: {company: 'Test Company', description: 'New Description'}
      response.should render_template('edit')
      client = Client.find_by_user_id(@user.id)
      flash[:notice].should eq('Your client account has been updated.')
      client.user_id.should eq(@user.id)
      client.description.should eq('New Description')
    end

    it 'should fail update if the parameters passed in are invalid' do
      post :update, user_id: @user.id, id: @client.id, client: {company: 's', description: 'New Description'}
      response.should render_template('edit')
      flash[:alert].should eq('Your client account could not be updated.')
      assigns(:client).errors[:company].should eq(['is too short (minimum is 2 characters)'])
      assigns(:client).company.should eq('s')
      @client.reload.company.should eq('Test Company')
    end
  end
end
