require 'spec_helper'

describe PaymentInfosController do
  before :each do
    @user = FactoryGirl.create(:user, checked_terms: true, country: 'CA', city: 'Vancouver')
    sign_in(@user)
  end

  describe 'GET edit' do
    it 'should fail when the user has not checked terms' do
      @user.checked_terms = false
      @user.save(validate: false)
      get :edit, user_id: @user.id
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end
  end
end
