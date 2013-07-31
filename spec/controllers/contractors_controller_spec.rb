require 'spec_helper'

describe ContractorsController do

  def valid_contractor(user_id)
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
    it 'assigns @contractors and renders template' do
      contractor = FactoryGirl.create(:contractor)
      get :index
      expect(assigns(:contractors)).to eq([contractor])
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
      @contractor = FactoryGirl.create(:contractor)
    end

    it 'assigns @contractor and renders template' do
      get :show, id: @contractor.id
      expect(assigns(:contractor)).to eq(@contractor)
      expect(response).to render_template('show')
    end

    it 'still renders the show template logged out' do
      sign_out(@user)
      get :show, id: @contractor.id
      expect(response).to render_template('show')
    end

    it 'fails gracefully when the contractor id does not exist' do
      get :show, id: 9999999
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Information cannot be found.')
    end

    # TODO: When you can disable a profile, they should not be available to anyone other than the contractor
  end

  describe 'GET new' do
    it 'should not be allowed when logged out' do
      sign_out(@user)
      get :new
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Permission Denied.')
    end

    it 'assigns @contractor to a new object where the user_id is that of the user, and renders template' do
      get :new
      expect(assigns(:contractor).new_record?).to be_true
      expect(assigns(:contractor).user_id).to eq(@user.id)
      expect(response).to render_template('new')
    end

    it 'should not be allowed when the user already has a user object' do
      FactoryGirl.create(:contractor, user: @user)
      get :new
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('You are already a contractor.')
    end
  end

  describe 'POST create' do
    it 'should not be allowed when logged out' do
      sign_out(@user)
      post :create, contractor: valid_contractor(@user.id)
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Permission Denied.')
    end

    it 'should not be allowed if the user_id does not match the id of the user' do
      assert_nil Contractor.find_by_user_id(@user.id)
      other_user = FactoryGirl.create(:user)
      post :create, contractor: valid_contractor(other_user.id)
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Permission Denied.')
      assert_nil Contractor.find_by_user_id(@user.id)
    end

    it 'should fail if the parameters passed in are invalid' do
      invalid_contractor = valid_contractor(@user.id)
      invalid_contractor[:rate] = 10000000
      post :create, contractor: invalid_contractor
      expect(response).to render_template('new')
      expect(assigns(:contractor).errors[:rate]).to eq(['must be less than or equal to 500'])
    end

    it 'should redirect to show and create the contractor' do
      assert_nil Contractor.find_by_user_id(@user.id)
      post :create, contractor: valid_contractor(@user.id)
      contractor = Contractor.find_by_user_id(@user.id)
      response.should redirect_to(contractor_path(contractor))
      expect(contractor.user_id).to eq(@user.id)
    end
  end

  describe 'GET edit' do
    it 'should not be allowed when logged out' do
      sign_out(@user)
      contractor = FactoryGirl.create(:contractor)
      get :edit, id: contractor.id
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Permission Denied.')
    end

    it 'should not be allowed when user has no contractor' do
      contractor = FactoryGirl.create(:contractor)
      get :edit, id: contractor.id
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Permission Denied.')
    end

    it 'should not be allowed when the contractor id is different from that of the user' do
      contractor = FactoryGirl.create(:contractor, user: @user)
      other_contractor = FactoryGirl.create(:contractor)
      get :edit, id: other_contractor.id
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Permission Denied.')
    end

    it 'should assign @contractor and render view when contractor id is correct' do
      contractor = FactoryGirl.create(:contractor, user: @user)
      get :edit, id: contractor.id
      expect(assigns(:contractor)).to eq(contractor)
      expect(response).to render_template('edit')
    end
  end

  describe 'POST update' do
    before :each do
      @contractor = FactoryGirl.create(:contractor, user: @user, rate: 20)
    end

    it 'should not be allowed when logged out' do
      sign_out(@user)
      post :update, id: @contractor.id, contractor: valid_contractor(@user.id)
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Permission Denied.')
    end

    it 'should not be allowed if id refers to a contractor not associated with the user' do
      other_contractor = FactoryGirl.create(:contractor)
      post :update, id: other_contractor.id, contractor: valid_contractor(other_contractor.user_id)
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Permission Denied.')
      expect(Contractor.find_by_user_id(@user.id)).to eq(@contractor)
    end

    it 'should ignore the user_id parameter, redirect to show and update the contractor' do
      contractor_params = valid_contractor('user-id-ignored')
      contractor_params[:rate] = 500
      post :update, id: @contractor.id, contractor: contractor_params
      contractor = Contractor.find_by_user_id(@user.id)
      response.should redirect_to(contractor_path(contractor))
      expect(contractor.user_id).to eq(@user.id)
      expect(contractor.rate).to eq(500)
    end

    it 'should fail if the parameters passed in are invalid' do
      invalid_contractor = valid_contractor(@user.id)
      invalid_contractor[:rate] = 1000000
      post :update, id: @contractor.id, contractor: invalid_contractor
      expect(response).to render_template('edit')
      expect(assigns(:contractor).errors[:rate]).to eq(['must be less than or equal to 500'])
      # The rate in @contractor should be 1000000, because the user will see the input they typed in.
      expect(assigns(:contractor).rate).to eq(1000000)
      expect(@contractor.reload.rate).to eq(20)
    end

  end

end
