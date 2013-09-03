class ResumeItem < ActiveRecord::Base
  include HasTimePeriod

  belongs_to :programmer

  validates :company_name, presence: true
end
