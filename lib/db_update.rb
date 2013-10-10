class DbUpdate
  def self.update_skills
    Skill::LIST.each do |skill_name|
      Skill.create(name: skill_name) unless Skill.find_by_name(skill_name)
    end
  end

  def self.seed_data_for_development
    for i in 1..10 do
      user = User.create(full_name: "Test User #{i}",
                         email: "test-user-#{i}@example.com",
                         password: 'fakepassword',
                         checked_terms: true,
                         city: 'Vancouver',
                         country: 'CA')
      Programmer.create(title: "Test Title #{i}",
                        rate: (20 + i),
                        availability: (i.even? ? 'full-time' : 'part-time'),
                        onsite_status: (i.even? ? 'offsite' : 'occasional'),
                        visibility: (i.even? ? 'public' : 'codedoor'),
                        state: 'activated',
                        qualified: true,
                        skills: [Skill.find(i)],
                        description: "This is test programmer #{i}.  The description is where the programmer tries to convince clients that he or she has what it takes to do a great job with whatever task is at hand.",
                        user: user)
    end
  end
end
