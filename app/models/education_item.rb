class EducationItem < ActiveRecord::Base
  include HasTimePeriod

  belongs_to :programmer

  validates :school_name, presence: true
end
