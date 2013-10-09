namespace :db do
  desc 'Make sure list of skills correspond to skill models'
  task update_skills: :environment do
    DbUpdate.update_skills
  end
end
