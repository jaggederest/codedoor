require 'spec_helper'

describe ProgrammersController do

  def valid_programmer(user_id)
    {user_id: user_id,
     title: 'title',
     description: 'description',
     rate: 50,
     availability: 'full-time',
     onsite_status: 'occasional',
     visibility: 'public',
     resume_items_attributes:
       {"1377632429748" =>
         {company_name: 'test company',
          title: 'test title',
          description: 'description',
          month_started: 'June',
          year_started: 2010,
          month_finished: 'January',
          year_finished: 2011,
          _destroy: 'false'}
       },
     contract_to_hire: true}
  end

  before :each do
    @user = FactoryGirl.create(:user, checked_terms: true, country: 'US')
    sign_in(@user)
  end

  describe 'GET index' do
    it 'assigns @programmers and renders template' do
      programmer = FactoryGirl.create(:programmer)
      get :index
      assigns(:programmers).should eq([programmer])
      response.should render_template('index')
    end

    it 'still renders the index template logged out' do
      sign_out(@user)
      get :index
      response.should render_template('index')
    end
  end

  describe 'GET show' do
    before :each do
      @programmer = FactoryGirl.create(:programmer)
    end

    it 'assigns @programmer and renders template' do
      get :show, id: @programmer.id
      assigns(:programmer).should eq(@programmer)
      response.should render_template('show')
    end

    it 'still renders the show template logged out if the programmer is public' do
      sign_out(@user)
      @programmer.visibility = 'public'
      @programmer.save!
      get :show, id: @programmer.id
      response.should render_template('show')
    end

    it 'does not render the show template logged out if the programmer is not public' do
      sign_out(@user)
      get :show, id: @programmer.id
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end

    it 'fails gracefully when the programmer id does not exist' do
      get :show, id: 9999999
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end

    # TODO: When you can disable a profile, they should not be available to anyone other than the programmer
  end

  describe 'GET edit' do

    it 'should load github repos, assign @programmer and render view when programmer id is correct' do
      programmer = FactoryGirl.create(:programmer, user: @user)
      FactoryGirl.create(:github_user_account, user: @user)
      GithubUserAccount.any_instance.should_receive(:load_repos).exactly(:once).and_return([])
      get :edit, user_id: @user.id, id: programmer.id
      assigns(:programmer).should eq(programmer)
      response.should render_template('edit')
    end

    it 'should not be allowed when terms are not checked' do
      programmer = FactoryGirl.create(:programmer, user: @user)
      @user.checked_terms = false
      @user.save(validate: false)
      get :edit, user_id: @user.id, id: programmer.id
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end

    it 'should not be allowed when logged out' do
      sign_out(@user)
      programmer = FactoryGirl.create(:programmer)
      get :edit, user_id: @user.id, id: programmer.id
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end

    it 'should not be allowed when user has no programmer' do
      programmer = FactoryGirl.create(:programmer)
      get :edit, user_id: @user.id, id: programmer.id
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end

    it 'should not be allowed when the programmer id is different from that of the user' do
      programmer = FactoryGirl.create(:programmer, user: @user)
      other_programmer = FactoryGirl.create(:programmer)
      get :edit, user_id: @user.id, id: other_programmer.id
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end

  end

  describe 'POST update' do
    before :each do
      @programmer = FactoryGirl.create(:programmer, user: @user, rate: 20, state: :activated)
    end

    it 'should ignore the user_id parameter, redirect to show and update the programmer' do
      programmer_params = valid_programmer('user-id-ignored')
      programmer_params[:rate] = 500
      post :update, user_id: @user.id, id: @programmer.id, programmer: programmer_params
      programmer = Programmer.find_by_user_id(@user.id)
      response.should redirect_to(programmer_path(programmer))
      flash[:notice].should eq('Your programmer account has been updated.')
      programmer.user_id.should eq(@user.id)
      programmer.rate.should eq(500)
    end

    it 'should say that the programmer was created if the programmer was not activated' do
      @programmer.update_columns(state: 'incomplete')
      programmer_params = valid_programmer('user-id-ignored')
      programmer_params[:rate] = 500
      post :update, user_id: @user.id, id: @programmer.id, programmer: programmer_params
      flash[:notice].should eq('Your programmer account has been created.')
    end

    it 'should not be allowed when terms are not checked' do
      @user.checked_terms = false
      @user.save(validate: false)
      programmer_params = valid_programmer('user-id-ignored')
      post :update, user_id: @user.id, id: @programmer.id, programmer: programmer_params
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end

    it 'should not be allowed when logged out' do
      sign_out(@user)
      post :update, user_id: @user.id, id: @programmer.id, programmer: valid_programmer(@user.id)
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end

    it 'should not be allowed if id refers to a programmer not associated with the user' do
      other_programmer = FactoryGirl.create(:programmer)
      post :update, user_id: @user.id, id: other_programmer.id, programmer: valid_programmer(other_programmer.user_id)
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
      Programmer.find_by_user_id(@user.id).should eq(@programmer)
    end

    it 'should fail if the parameters passed in are invalid' do
      invalid_programmer = valid_programmer(@user.id)
      invalid_programmer[:rate] = 1000000
      post :update, user_id: @user.id, id: @programmer.id, programmer: invalid_programmer
      response.should render_template('edit')
      flash[:alert].should eq('Your programmer account could not be updated.')
      assigns(:programmer).errors[:rate].should eq(['must be less than or equal to 1000'])
      # The rate in @programmer should be 1000000, because the user will see the input they typed in.
      assigns(:programmer).rate.should eq(1000000)
      @programmer.reload.rate.should eq(20)
    end

  end

end
