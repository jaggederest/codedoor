class Programmer < ActiveRecord::Base
  include HasRate

  # TODO: Add real ranking system, but this at least incentivizes creating instead of penalizing updating
  default_scope { order('id ASC') }

  belongs_to :user

  has_many :github_repos, dependent: :destroy
  has_many :portfolio_items, dependent: :destroy
  has_many :resume_items, dependent: :destroy
  has_many :education_items, dependent: :destroy
  accepts_nested_attributes_for :github_repos
  accepts_nested_attributes_for :portfolio_items, allow_destroy: true
  accepts_nested_attributes_for :resume_items, allow_destroy: true
  accepts_nested_attributes_for :education_items, allow_destroy: true

  has_many :jobs

  has_and_belongs_to_many :skills

  validates :user_id, presence: true, uniqueness: true
  validates :title, length: { minimum: 5, maximum: 80 }
  validates :rate, numericality: { greater_than_or_equal_to: 20, less_than_or_equal_to: 1000, only_integer: true }
  validates :availability, inclusion: { in: ['part-time', 'full-time', 'unavailable'], message: 'must be selected' }
  validates :calculated_availability, inclusion: { in: ['part-time', 'full-time', 'unavailable'], message: 'must be selected' }
  validates :onsite_status, inclusion: { in: ['offsite', 'visits_allowed', 'occasional', 'onsite'], message: 'must be selected' }
  validates :visibility, inclusion: { in: ['public', 'codedoor', 'private'], message: 'must be selected' }

  validate :has_skills?

  before_validation :calculate_calculated_availability
  before_update {|programmer| programmer.activate! if programmer.incomplete? && programmer.valid? }

  state_machine :state, initial: :incomplete do
    event :activate do
      transition incomplete: :activated
    end

    event :disable do
      transition all => :disabled
    end
  end

  self.per_page = 10

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

  def unavailable?
    availability == 'unavailable'
  end

  def private?
    visibility == 'private'
  end

  def visible_to_others?
    activated? && !private? && qualified?
  end

  def show_repos?
    !github_repos.shown.empty?
  end

  def show_portfolio?
    !portfolio_items.empty?
  end

  def show_resume?
    !resume_items.empty?
  end

  def show_education?
    !education_items.empty?
  end

  def self.client_rate_to_programmer_rate(client_rate)
    (client_rate * 8.0 / 9.0).round(2)
  end

  def username
    user.github_account.username
  end

  def calculate_calculated_availability
    if jobs.where(state: 'running').count > 0
      self.calculated_availability = 'unavailable'
    else
      self.calculated_availability = availability
    end
  end

  private

  def has_skills?
    errors.add(:skills, 'have not been selected') if skills.blank?
  end

end
