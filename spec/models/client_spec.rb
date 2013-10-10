require 'spec_helper'

describe Client do

  context 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_uniqueness_of(:user_id) }

    it { should ensure_length_of(:company).is_at_least(2).is_at_most(80) }
    it { should validate_uniqueness_of(:company) }
  end
end
