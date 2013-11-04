class Client < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true, uniqueness: true
  validates :company, length: { minimum: 2, maximum: 80 }, uniqueness: true

  has_many :jobs
end
