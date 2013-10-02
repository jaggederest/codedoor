require 'spec_helper'

describe PaymentInfosController do
  before :each do
    @user = FactoryGirl.create(:user, checked_terms: true, country: 'CA', city: 'Vancouver')
    sign_in(@user)
  end

  describe 'GET edit' do
    it 'should create payment_info for the user if it does not exist, and render template' do
      get :edit, user_id: @user.id
      assigns(:payment_info).user.should eq(@user)
      assigns(:cards).should eq([])
      response.should render_template('edit')
    end

    it 'should return payment_info for the user if it exists' do
      payment_info = FactoryGirl.create(:payment_info, user: @user)
      get :edit, user_id: @user.id
      assigns(:payment_info).should eq(payment_info)
    end

    it 'should fail when the user has not checked terms' do
      @user.checked_terms = false
      @user.save(validate: false)
      get :edit, user_id: @user.id
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end
  end

  def should_json_redirect(response, user)
    ActiveSupport::JSON.decode(response.body).should eq({'redirect_to' => edit_user_payment_info_path(user)})
  end

  describe 'POST update' do
    it 'should associate the card to the user' do
      payment_info = FactoryGirl.create(:payment_info, user: @user)
      PaymentInfo.any_instance.should_receive(:associate_card).with('TESTVALUE').exactly(1).times {}
      post :update, user_id: @user.id, data: {uri: 'TESTVALUE'}
    end

    it 'should add errors to flash' do
      post :update, user_id: @user.id, error: {'key_of_error' => 'value_of_error'}
      flash[:errors].should eq(['key_of_error: value_of_error'])
      should_json_redirect(response, @user)
    end

    it 'should return error if errors is some kind of non-hash' do
      post :update, user_id: @user.id, error: ['Balanced API returned an array before, do not 500']
      flash[:alert].should eq('There was something wrong with processing the payment details.')
      should_json_redirect(response, @user)
    end

    it 'should return error if security check failed' do
      post :update, user_id: @user.id, data: {security_code_check: 'failed'}
      flash[:alert].should eq('Your security code is invalid, please try again.')
      should_json_redirect(response, @user)
    end

    it 'should return error if there is no uri' do
      post :update, user_id: @user.id, data: {no_uri: 'TESTVALUE'}
      flash[:alert].should eq('There was something wrong with processing the payment details.')
      should_json_redirect(response, @user)
    end

    it 'should fail when the user has not checked terms' do
      @user.checked_terms = false
      @user.save(validate: false)
      post :update, user_id: @user.id
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end

  end

end
