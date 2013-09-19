require 'spec_helper'

describe PaymentInfosController do
  before :each do
    @user = FactoryGirl.create(:user, checked_terms: true, country: 'CA', city: 'Vancouver')
    sign_in(@user)
  end

  describe 'GET new' do
    it 'should assign @payment_info and render view' do
      get :new, user_id: @user.id
      assigns(:payment_info).user_id.should eq(@user.id)
      response.should render_template('new')
    end

    it 'should redirect to edit if payment info exists' do
      FactoryGirl.create(:payment_info, user: @user)
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
    it 'should ignore the user_id parameter and update the payment info' do
      post :create, user_id: @user.id, payment_info: {user_id: 'ignore', primary_payment_method: 'balanced'}
      response.should render_template('edit')
      payment_info = PaymentInfo.find_by_user_id(@user.id)
      flash[:notice].should eq('Your payment information has been created.')
      payment_info.user_id.should eq(@user.id)
      payment_info.primary_payment_method.should eq('balanced')
    end

    it 'should fail create if the parameters passed in are invalid' do
      post :create, user_id: @user.id, payment_info: {primary_payment_method: 'invalid'}
      response.should render_template('new')
      flash[:alert].should eq('Your payment information could not be created.')
      assigns(:payment_info).errors[:primary_payment_method].should eq(['must be selected'])
      assigns(:payment_info).primary_payment_method.should eq('invalid')
    end
  end

  describe 'GET edit' do
    before :each do
      @payment_info = FactoryGirl.create(:payment_info, user: @user, primary_payment_method: 'paypal')
    end

    it 'should assign @payment_info and render view' do
      get :edit, user_id: @user.id
      assigns(:payment_info).user_id.should eq(@user.id)
      response.should render_template('edit')
    end

    it 'should fail when the user has not checked terms' do
      @user.checked_terms = false
      @user.save(validate: false)
      get :new, user_id: @user.id
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end
  end

  describe 'POST update' do
    before :each do
      @payment_info = FactoryGirl.create(:payment_info, user: @user, primary_payment_method: 'paypal')
    end

    it 'should ignore the user_id parameter and update the payment info' do
      post :update, user_id: @user.id, id: @payment_info.id, payment_info: {user_id: 'ignore', primary_payment_method: 'balanced'}
      response.should render_template('edit')
      payment_info = PaymentInfo.find_by_user_id(@user.id)
      flash[:notice].should eq('Your payment information has been updated.')
      payment_info.user_id.should eq(@user.id)
      payment_info.primary_payment_method.should eq('balanced')
    end

    it 'should fail update if the parameters passed in are invalid' do
      post :update, user_id: @user.id, id: @payment_info.id, payment_info: {primary_payment_method: 'invalid'}
      response.should render_template('edit')
      flash[:alert].should eq('Your payment information could not be updated.')
      assigns(:payment_info).errors[:primary_payment_method].should eq(['must be selected'])
      assigns(:payment_info).primary_payment_method.should eq('invalid')
      @payment_info.reload.primary_payment_method.should eq('paypal')
    end
  end
end
