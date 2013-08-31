require 'spec_helper'

describe UsersController do
  before :each do
    @user = FactoryGirl.create(:user)
    sign_in(@user)
  end

  describe 'GET edit' do
    it 'should render view when logged in' do
      get :edit, id: @user.id
      expect(response).to render_template('edit')
    end

    it 'should fail if the id is not the id of the user' do
      other_user = FactoryGirl.create(:user)
      get :edit, id: other_user.id
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Information cannot be found.')
    end

    it 'should not be allowed when logged out' do
      sign_out(@user)
      get :edit, id: @user.id
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Information cannot be found.')
    end
  end

  describe 'POST update' do
    it 'should pass with correct inputs, redirect to programmer page' do
      post :update, id: @user.id, user: {full_name: 'New Name', email: 'newemail@example.com', checked_terms: '1', country: 'US'}
      response.should redirect_to(edit_user_programmer_path(@user))
      @user.reload
      expect(flash[:notice]).to eq('Your information has been updated.')
      expect(@user.full_name).to eq('New Name')
      expect(@user.email).to eq('newemail@example.com')
    end

    it 'should not be allowed when logged out' do
      sign_out(@user)
      post :update, id: @user.id, user: {full_name: 'New Name', email: 'newemail@example.com', checked_terms: '1', country: 'US'}
      response.should redirect_to(root_path)
      expect(flash[:alert]).to eq('Information cannot be found.')
    end

    it 'should fail if the Terms of Use are not checked' do
      post :update, id: @user.id, user: {full_name: 'New Name', email: 'newemail@example.com', country: 'US'}
      expect(response).to render_template('edit')
      expect(flash[:alert]).to eq('Your information could not be updated.')
      expect(assigns(:current_user).errors[:checked_terms]).to eq(['^The Terms of Use must be accepted.'])
    end

    it 'should fail if the parameters passed in are invalid' do
      post :update, id: @user.id, user: {full_name: 'New Name', email: '', checked_terms: '1', country: 'US'}
      expect(response).to render_template('edit')
      expect(flash[:alert]).to eq('Your information could not be updated.')
      expect(assigns(:current_user).errors[:email]).to eq(['can\'t be blank'])
    end

  end

end
