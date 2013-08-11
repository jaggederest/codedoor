require 'spec_helper'

describe UsersController do
  before :each do
    @user = FactoryGirl.create(:user)
    sign_in(@user)
  end

  describe 'GET edit' do
    it 'should not be allowed when logged out' do
      pending('must implement')
    end

    it 'should not be allowed when Terms of Use are not checked' do
      pending('must implement')
    end

    it 'should render view when logged in' do
      pending('must implement')
    end
  end

  describe 'POST update' do
    it 'should pass with correct inputs, redirect to programmer page' do
      pending('must implement')
    end

    it 'should not be allowed when logged out' do
      pending('must implement')
    end

    it 'should fail if the Terms of Use are not checked' do
      pending('must implement')
    end

    it 'should fail if the parameters passed in are invalid' do
      pending('must implement')
    end

  end

end
