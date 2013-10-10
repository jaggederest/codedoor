require 'spec_helper'

describe Skill do
  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { ensure_inclusion_only_of(Skill, :name, Skill::LIST) }
  end
end
