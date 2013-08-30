class Programmer < ActiveRecord::Base

  belongs_to :user

  has_many :github_repos, dependent: :destroy
  has_many :resume_items, dependent: :destroy
  accepts_nested_attributes_for :resume_items, allow_destroy: true

  scope :not_private, -> { where(:visibility != 'private') }

  validates :user_id, presence: true, uniqueness: true
  validates :title, length: { minimum: 5, maximum: 80 }
  validates :rate, numericality: { greater_than_or_equal_to: 20, less_than_or_equal_to: 1000, only_integer: true }
  validates :availability, inclusion: { in: ['part-time', 'full-time', 'unavailable'], message: 'must be selected' }
  validates :onsite_status, inclusion: { in: ['offsite', 'visits_allowed', 'occasional', 'onsite'], message: 'must be selected' }
  validates :visibility, inclusion: { in: ['public', 'codedoor', 'private'], message: 'must be selected' }

  def daily_rate_to_programmer
    rate.nil? ? nil : (rate * 8)
  end

  def daily_rate_to_client
    rate.nil? ? nil : (rate * 9)
  end

  def hourly_rate_to_client
    rate.nil? ? nil : (rate * 9.0 / 8.0).round(2)
  end

  def daily_fee_to_codedoor
    rate.nil? ? nil : rate
  end

  def hourly_fee_to_codedoor
    rate.nil? ? nil : (rate / 8.0).round(2)
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
