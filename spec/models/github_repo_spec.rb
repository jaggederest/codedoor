require 'spec_helper'

describe GithubRepo do
  context 'validations' do
    it { should validate_presence_of(:programmer_id) }
    it { should validate_presence_of(:repo_owner) }
    it { should validate_presence_of(:repo_name) }
    it { should validate_presence_of(:default_branch) }
  end
end
