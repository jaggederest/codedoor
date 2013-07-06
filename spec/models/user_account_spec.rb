require 'spec_helper'

describe UserAccount do
  context 'validations' do
    it { should validate_presence_of(:account_id) }
    it { should validate_uniqueness_of(:account_id).scoped_to(:user_id) }
    it { should validate_presence_of(:oauth_token) }
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:user) }
  end

  context 'associations' do
    it { should belong_to(:user) }
  end
end
