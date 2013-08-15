class Programmer < ActiveRecord::Base

  belongs_to :user

  validates :user_id, presence: true, uniqueness: true
  validates :title, length: { minimum: 5, maximum: 80 }
  validates :rate, numericality: { greater_than_or_equal_to: 20, less_than_or_equal_to: 1000, only_integer: true }
  validates :time_status, inclusion: { in: ['part-time', 'full-time'], message: 'must be selected' }
  validates :onsite_status, inclusion: { in: ['offsite', 'visits_allowed', 'occasional', 'onsite'], message: 'must be selected' }
  validates :visibility, inclusion: { in: ['public', 'codedoor', 'private'], message: 'must be selected' }

  def daily_rate_to_programmer
    rate * 8
  end

  def daily_rate_to_client
    rate * 9
  end

  def self.onsite_status_description(status)
    case status.to_sym
    when :onsite
      'Work can be done at a client\'s office if it is nearby.'
    when :occasional
      'Work can occasionally be done at a client\'s office if it is nearby.'
    when :visits_allowed
      'Clients can visit the programmer\'s office if they wish.'
    when :offsite
      'All work is to be done remotely.'
    else
      raise 'Invalid Onsite Status'
    end
  end

  def private?
    self.visibility == 'private'
  end

end
