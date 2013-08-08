require 'spec_helper'

describe ProgrammersController do

  def valid_programmer(user_id)
    {user_id: user_id,
     title: 'title',
     description: 'description',
     rate: 50,
     time_status: 'full-time',
     client_can_visit: true,
     onsite_status: 'occasional',
     contract_to_hire: true}
  end

  before :each do
    @user = FactoryGirl.create(:user)
    sign_in(@user)
  end

  describe 'GET index' do
    it 'assigns @programmers and renders template' do
      programmer = FactoryGirl.create(:programmer)
      get :index
      expect(assigns(:programmers)).to eq([programmer])
      expect(response).to render_template('index')
    end

    it 'still renders the index template logged out' do
      sign_out(@user)
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET show' do
    before :each do
      @programmer = FactoryGirl.create(:programmer)
    end

    it 'assigns @programmer and renders template' do
      get :show, id: @programmer.id
      expect(assigns(:programmer)).to eq(@programmer)
      expect(response).to render_template('show')
    end

    it 'still renders the show template logged out' do
      sign_out(@user)
      get :show, id: @programmer.id
      expect(response).to render_template('show')
    end

    it 'fails gracefully when the programmer id does not exist' do
      get :show, id: 9999999
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Information cannot be found.')
    end

    # TODO: When you can disable a profile, they should not be available to anyone other than the programmer
  end

  describe 'GET new' do
    it 'should not be allowed when logged out' do
      sign_out(@user)
      get :new
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Permission Denied.')
    end

    it 'assigns @programmer to a new object where the user_id is that of the user, and renders template' do
      get :new
      expect(assigns(:programmer).new_record?).to be_true
      expect(assigns(:programmer).user_id).to eq(@user.id)
      expect(response).to render_template('new')
    end

    it 'should not be allowed when the user already has a user object' do
      FactoryGirl.create(:programmer, user: @user)
      get :new
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('You are already a programmer.')
    end
  end

  describe 'POST create' do
    it 'should not be allowed when logged out' do
      sign_out(@user)
      post :create, programmer: valid_programmer(@user.id)
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Permission Denied.')
    end

    it 'should not be allowed if the user_id does not match the id of the user' do
      assert_nil Programmer.find_by_user_id(@user.id)
      other_user = FactoryGirl.create(:user)
      post :create, programmer: valid_programmer(other_user.id)
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Permission Denied.')
      assert_nil Programmer.find_by_user_id(@user.id)
    end

    it 'should fail if the parameters passed in are invalid' do
      invalid_programmer = valid_programmer(@user.id)
      invalid_programmer[:rate] = 10000000
      post :create, programmer: invalid_programmer
      expect(response).to render_template('new')
      expect(assigns(:programmer).errors[:rate]).to eq(['must be less than or equal to 1000'])
    end

    it 'should redirect to show and create the programmer' do
      assert_nil Programmer.find_by_user_id(@user.id)
      post :create, programmer: valid_programmer(@user.id)
      programmer = Programmer.find_by_user_id(@user.id)
      response.should redirect_to(programmer_path(programmer))
      expect(programmer.user_id).to eq(@user.id)
    end
  end

  describe 'GET edit' do
    it 'should not be allowed when logged out' do
      sign_out(@user)
      programmer = FactoryGirl.create(:programmer)
      get :edit, id: programmer.id
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Permission Denied.')
    end

    it 'should not be allowed when user has no programmer' do
      programmer = FactoryGirl.create(:programmer)
      get :edit, id: programmer.id
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Permission Denied.')
    end

    it 'should not be allowed when the programmer id is different from that of the user' do
      programmer = FactoryGirl.create(:programmer, user: @user)
      other_programmer = FactoryGirl.create(:programmer)
      get :edit, id: other_programmer.id
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Permission Denied.')
    end

    it 'should assign @programmer and render view when programmer id is correct' do
      programmer = FactoryGirl.create(:programmer, user: @user)
      get :edit, id: programmer.id
      expect(assigns(:programmer)).to eq(programmer)
      expect(response).to render_template('edit')
    end
  end

  describe 'POST update' do
    before :each do
      @programmer = FactoryGirl.create(:programmer, user: @user, rate: 20)
    end

    it 'should not be allowed when logged out' do
      sign_out(@user)
      post :update, id: @programmer.id, programmer: valid_programmer(@user.id)
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Permission Denied.')
    end

    it 'should not be allowed if id refers to a programmer not associated with the user' do
      other_programmer = FactoryGirl.create(:programmer)
      post :update, id: other_programmer.id, programmer: valid_programmer(other_programmer.user_id)
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Permission Denied.')
      expect(Programmer.find_by_user_id(@user.id)).to eq(@programmer)
    end

    it 'should ignore the user_id parameter, redirect to show and update the programmer' do
      programmer_params = valid_programmer('user-id-ignored')
      programmer_params[:rate] = 500
      post :update, id: @programmer.id, programmer: programmer_params
      programmer = Programmer.find_by_user_id(@user.id)
      response.should redirect_to(programmer_path(programmer))
      expect(programmer.user_id).to eq(@user.id)
      expect(programmer.rate).to eq(500)
    end

    it 'should fail if the parameters passed in are invalid' do
      invalid_programmer = valid_programmer(@user.id)
      invalid_programmer[:rate] = 1000000
      post :update, id: @programmer.id, programmer: invalid_programmer
      expect(response).to render_template('edit')
      expect(assigns(:programmer).errors[:rate]).to eq(['must be less than or equal to 1000'])
      # The rate in @programmer should be 1000000, because the user will see the input they typed in.
      expect(assigns(:programmer).rate).to eq(1000000)
      expect(@programmer.reload.rate).to eq(20)
    end

  end

end
