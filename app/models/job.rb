class Job < ActiveRecord::Base
  belongs_to :client
  belongs_to :programmer
  has_many :job_messages, dependent: :destroy
  accepts_nested_attributes_for :job_messages

  validates :client_id, presence: true
  validates :programmer_id, presence: true
  validates :name, presence: true
  validates :rate, presence: true
  validate :client_and_programmer_are_different
  validate :rate_is_unchanged, on: :update

  state_machine :state, initial: :has_not_started do
    event :offer do
      transition has_not_started: :offered
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

  def client_and_programmer_are_different
    # NOTE: This would only throw an exception if the client or programmer are missing, but that's invalid
    begin
      errors.add(:programmer, 'must refer to a different user') if client.user == programmer.user
    rescue
    end
  end

  def rate_is_unchanged
    errors.add(:rate, 'must stay the same for the job') if rate_changed? && running?
  end

  def is_client?(user)
    raise 'Called is_client? for non-user' unless user.kind_of?(User)
    client.user == user
  end

end
