FactoryGirl.define do
  factory :github_repo do
    sequence :repo_owner do |n|
      "owner-#{n}"
    end
    sequence :repo_name do |n|
      "name-#{n}"
    end
    default_branch 'master'
    programmer
  end
end
