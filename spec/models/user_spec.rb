require 'spec_helper'

describe User do
  context 'validations' do
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }

    it 'should require that the Terms of Use are checked on update' do
      user = FactoryGirl.create(:user, country: 'US')
      user.full_name = 'Changing name'
      user.valid?.should be_false
      user.checked_terms = true
      user.valid?.should be_true
    end

    it 'should require that a country is selected if the terms are checked' do
      user = FactoryGirl.create(:user)
      user.checked_terms = true
      user.valid?
      user.errors[:country].should eq(['can\'t be blank'])
    end

    it 'should not require that the Terms of Use are checked to be created' do
      user = User.new(full_name: 'Test User Creation', email: 'user@creation.com', password: 'usercreation')
      user.save.should be_true
    end
  end

  context 'associations' do
    it { should have_many(:user_accounts) }
    it { should have_one(:programmer) }
  end

  context 'abilities' do
    let(:user) { FactoryGirl.create(:user) }
    let(:ability) { Ability.new(user) }

    it 'show allow a user to manage him or herself' do
      ability.should be_able_to(:read,    user)
      ability.should be_able_to(:create,  user)
      ability.should be_able_to(:update,  user)
      ability.should be_able_to(:destroy, user)
    end

    it 'should not allow a user to do anything about other users' do
      other_user = FactoryGirl.create(:user)
      ability.should_not be_able_to(:read,    other_user)
      ability.should_not be_able_to(:create,  other_user)
      ability.should_not be_able_to(:update,  other_user)
      ability.should_not be_able_to(:destroy, other_user)
    end

    it 'should not allow logged out users to see users' do
      ability = Ability.new(nil)
      ability.should_not be_able_to(:read,    user)
      ability.should_not be_able_to(:create,  user)
      ability.should_not be_able_to(:update,  user)
      ability.should_not be_able_to(:destroy, user)
    end
  end

  context 'find_for_github_oauth' do
    it 'should create a new user if the there is no UserAccount with that account id' do
      email = "email#{rand}@example.com"
      auth = MockGitHubAuth.test_user
      auth[:info][:email] = email
      user = User.find_for_github_oauth(auth)
      user.full_name.should eq('Test User')
      user.email.should eq(email)

      user_account = GithubUserAccount.where(account_id: 'test account id').first
      user_account.user.should eq(user)
      user_account.oauth_token.should eq('oauth token')
    end

    it 'should return user if the there is a UserAccount that matches' do
      user_account = FactoryGirl.create(:user_account, type: 'GithubUserAccount', account_id: 'existing account id')
      auth = OmniAuth::AuthHash.new({uid: 'existing account id'})
      user_account.user.should eq(User.find_for_github_oauth(auth))
    end
  end

  context 'github_account' do
    it 'should be nil when there is none' do
      user = FactoryGirl.create(:user)
      user.github_account.should be_nil
    end

    it 'should return the account when it exists' do
      user = FactoryGirl.create(:user)
      ua = FactoryGirl.create(:github_user_account, user: user)
      user.github_account.class.should eq(GithubUserAccount)
      user.github_account.user.should eq(user)
    end
  end
end
