require 'spec_helper'

describe UserAccount do
  context 'validations' do
    it { should validate_presence_of(:account_id) }

    it 'should validate uniqueness of account id scoped to type' do
      FactoryGirl.create(:user_account, account_id: 'account-id', type: 'type', user: FactoryGirl.create(:user))
      -> {FactoryGirl.create(:user_account, account_id: 'account-id', type: 'type', user: FactoryGirl.create(:user))}.should raise_error
    end

    it 'should validate uniqueness of account id scoped to user' do
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:user_account, account_id: 'account-id', type: 'type', user: user)
      -> {FactoryGirl.create(:user_account, account_id: 'account-id', type: 'type2', user: user)}.should raise_error
    end

    it 'should allow multiple copies of an account id if the type and user are different' do
      a1 = FactoryGirl.create(:user_account, account_id: 'account-id', type: 'type', user: FactoryGirl.create(:user))
      a2 = FactoryGirl.create(:user_account, account_id: 'account-id', type: 'type2', user: FactoryGirl.create(:user))
      a1.valid?.should be_true
      a2.valid?.should be_true
    end

    it { should validate_presence_of(:encrypted_oauth_token) }
    it { should validate_presence_of(:encrypted_oauth_token_iv) }
    it { should validate_presence_of(:encrypted_oauth_token_salt) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:username) }
  end

  context 'associations' do
    it { should belong_to(:user) }
  end
end
