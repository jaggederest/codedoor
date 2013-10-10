require 'spec_helper'

describe DbUpdate do
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

  context 'seed_data_for_development' do
    it 'should not throw an exception' do
      DbUpdate.seed_data_for_development
    end
  end
end
