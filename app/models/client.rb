class Client < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true, uniqueness: true
  validates :company, length: { minimum: 5, maximum: 80 }, uniqueness: true
end
