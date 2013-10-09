# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Insert production data here
DbUpdate.update_skills

# Insert test data here
if Rails.env.development?
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
                        description: "This is test programmer #{i}.  The description is where the programmer tries to convince clients that he or she has what it takes to do a great job with whatever task is at hand.",
                        user: user)
    end
end
