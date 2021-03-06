require 'spec_helper'

describe UsersController do
  before :each do
    @user = FactoryGirl.create(:user)
    sign_in(@user)
  end

  describe 'GET edit' do
    it 'should render view when logged in' do
      get :edit, id: @user.id
      response.should render_template('edit')
    end

    it 'should fail if the id is not the id of the user' do
      other_user = FactoryGirl.create(:user)
      get :edit, id: other_user.id
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end

    it 'should not be allowed when logged out' do
      sign_out(@user)
      get :edit, id: @user.id
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end
  end

  describe 'POST update' do
    it 'should pass with correct inputs' do
      post :update, id: @user.id, user: {full_name: 'New Name', email: 'newemail@example.com', checked_terms: '1', country: 'US', state: 'CA', city: 'Burlingame'}
      response.should render_template('edit')
      @user.reload
      flash[:notice].should eq('Your information has been updated.')
      @user.full_name.should eq('New Name')
      @user.email.should eq('newemail@example.com')
    end

    it 'should redirect to edit programmer path if button is clicked' do
      mailer = double
      UserMailer.should_receive(:welcome_email).and_return(mailer)
      mailer.should_receive(:deliver)
      post :update, id: @user.id, user: {full_name: 'New Name', email: 'newemail@example.com', checked_terms: '1', country: 'US', state: 'CA', city: 'Burlingame'}, create_programmer: 'Create Programmer Account'
      response.should redirect_to(edit_user_programmer_path(@user))
    end

    it 'should redirect to new client path if button is clicked' do
      mailer = double
      UserMailer.should_receive(:welcome_email).and_return(mailer)
      mailer.should_receive(:deliver)
      post :update, id: @user.id, user: {full_name: 'New Name', email: 'newemail@example.com', checked_terms: '1', country: 'US', state: 'CA', city: 'Burlingame'}, create_client: 'Create Client Account'
      response.should redirect_to(new_user_client_path(@user))
    end

    it 'should not be allowed when logged out' do
      sign_out(@user)
      post :update, id: @user.id, user: {full_name: 'New Name', email: 'newemail@example.com', checked_terms: '1', country: 'US'}
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end

    it 'should fail if the Terms of Use are not checked' do
      post :update, id: @user.id, user: {full_name: 'New Name', email: 'newemail@example.com', country: 'US'}
      response.should render_template('edit')
      flash[:alert].should eq('Your information could not be updated.')
      assigns(:current_user).errors[:checked_terms].should eq(['- The Terms of Use must be accepted.'])
    end

    it 'should fail if the parameters passed in are invalid' do
      post :update, id: @user.id, user: {full_name: 'New Name', email: '', checked_terms: '1', country: 'US'}
      response.should render_template('edit')
      flash[:alert].should eq('Your information could not be updated.')
      assigns(:current_user).errors[:email].sort.should eq(['can\'t be blank', 'is invalid'])
    end

  end

end
