require 'spec_helper'

describe User do
  context 'validations' do
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end

  context 'associations' do
    it { should have_many(:user_accounts) }
  end

  context 'find_for_github_oauth' do
    it 'should create a new user if the there is no UserAccount with that account id' do
      auth = OmniAuth::AuthHash.new({uid: 'new account id',
                                     provider: 'github',
                                     credentials: {token: 'oauth token'},
                                     info: {email: 'email@example.com'},
                                     extra: {raw_info: {name: 'Test User'}}})
      user = User.find_for_github_oauth(auth)
      assert_equal(user.full_name, 'Test User')
      assert_equal(user.email, 'email@example.com')

      user_account = UserAccount.where(provider: 'github', account_id: 'new account id').first
      assert_equal(user_account.user, user)
      assert_equal(user_account.oauth_token, 'oauth token')
    end

    it 'should return user if the there is a UserAccount that matches' do
      user_account = FactoryGirl.create(:user_account, provider: 'github', account_id: 'existing account id')
      auth = OmniAuth::AuthHash.new({provider: 'github', uid: 'existing account id'})
      assert_equal(user_account.user, User.find_for_github_oauth(auth))
    end
  end
end
