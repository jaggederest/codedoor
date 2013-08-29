require 'spec_helper'

describe UserAccount do
  context 'validations' do
    it { should validate_presence_of(:account_id) }
    it { should validate_uniqueness_of(:account_id).scoped_to(:user_id) }
    it { should validate_presence_of(:oauth_token) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:username) }
  end

  context 'associations' do
    it { should belong_to(:user) }
  end
end
