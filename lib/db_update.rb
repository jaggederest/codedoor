class DbUpdate
  def self.update_skills
    Skill::LIST.each do |skill_name|
      Skill.create(name: skill_name) unless Skill.find_by_name(skill_name)
    end
  end
end
