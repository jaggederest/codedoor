# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Insert production data here
DbUpdate.update_skills

# Insert test data here
if Rails.env.development?
  DbUpdate.seed_data_for_development
end
