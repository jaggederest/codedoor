class Job < ActiveRecord::Base
  include HasRate

  belongs_to :client
  belongs_to :programmer
  has_many :job_messages, dependent: :destroy
  accepts_nested_attributes_for :job_messages

  validates :client_id, presence: true
  validates :programmer_id, presence: true
  validates :name, presence: true
  validates :rate, presence: true
  validates :availability, inclusion: { in: ['part-time', 'full-time'], message: 'must be selected' }

  validate :client_and_programmer_are_different
  validate :rate_is_unchanged, unless: :has_not_or_has_just_started?
  validate :availability_is_unchanged, unless: :has_not_or_has_just_started?

  after_save :calculate_programmer_availability

  state_machine :state, initial: :has_not_started do
    event :offer do
      transition has_not_started: :offered
    end

    event :cancel do
      transition offered: :canceled
    end

    event :decline do
      transition offered: :declined
    end

    event :start do
      transition offered: :running
    end

    event :finish do
      transition [:offered, :running] => :finished
    end

    event :disable do
      transition all => :disabled
    end
  end

  def is_client?(user)
    raise 'Called is_client? for non-user' unless user.kind_of?(User)
    client.user == user
  end

  private

  def calculate_programmer_availability
    if finished? || disabled? || running?
      self.programmer.calculate_calculated_availability
      self.programmer.save!
    end
  end

  def client_and_programmer_are_different
    # NOTE: This would only throw an exception if the client or programmer are missing, but that's invalid
    begin
      errors.add(:programmer, 'must refer to a different user') if client.user == programmer.user
    rescue
    end
  end

  def has_not_or_has_just_started?
    state_was.nil? || state_was == 'has_not_started'
  end

  def rate_is_unchanged
    errors.add(:rate, 'must stay the same for the job') if rate_changed?
  end

  def availability_is_unchanged
    errors.add(:availability, 'must stay the same for the job') if availability_changed?
  end

end
