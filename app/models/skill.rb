class Skill < ActiveRecord::Base
  has_and_belongs_to_many :programmers

  # TODO: Make something that scales to many more skills
  # This is put before the validation statements, because it needs to be defined first
  LIST = ['Android', 'ActionScript', 'ASP.NET', 'Assembly', 'C', 'C#', 'C++', 'Clojure', 'Compilers', 'D',  'Django', 'Erlang', 'Go', 'Groovy', 'Hadoop', 'Haskell', 'iOS', 'Java', 'JavaScript', 'Lisp', 'Lua', 'Machine Learning', 'MATLAB', 'node.js', 'Objective-C', 'OpenGL', 'Pascal', 'Perl', 'PHP', 'Prolog', 'Python', 'R', 'Ruby', 'Ruby on Rails', 'Scala', 'Scheme', 'Smalltalk', 'Tech Operations', 'Visual Basic']

  validates :name, presence: true, uniqueness: true, inclusion: {in: LIST}
end
