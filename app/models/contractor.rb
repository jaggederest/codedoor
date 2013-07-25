class Contractor < ActiveRecord::Base

  belongs_to :user

  validates :user_id, presence: true, uniqueness: true
  validates :title, length: { minimum: 5, maximum: 80 }
  validates :rate, numericality: { greater_than_or_equal_to: 20, less_than_or_equal_to: 500, only_integer: true }
  validates :time_status, inclusion: { in: ['parttime', 'fulltime'] }
  validates :onsite_status, inclusion: { in: ['offsite', 'occasional', 'onsite'] }

end
