require 'spec_helper'

describe Skill do
  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { ensure_inclusion_only_of(Skill, :name, Skill::LIST) }
  end

  context 'DB Update Skills' do
    it 'should add skills that are missing when called, but not multiple times' do
      Skill.delete_all
      Skill.all.count.should eq(0)
      DbUpdate.update_skills
      Skill.all.count.should eq(Skill::LIST.count)

      Skill.all.each do |skill|
        Skill::LIST.include?(skill.name).should be_true
      end

      DbUpdate.update_skills
      Skill.all.count.should eq(Skill::LIST.count)
    end
  end
end
