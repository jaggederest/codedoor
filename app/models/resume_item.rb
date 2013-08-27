class ResumeItem < ActiveRecord::Base

  belongs_to :programmer

  validates :programmer_id, presence: true, uniqueness: true
  validates :company_name, presence: true
  validates :year_started, numericality: { greater_than: 1900, less_than: 2014 }
  validates :year_finished, numericality: { greater_than: 1900, less_than: 2014, allow_nil: true}
  validates :month_started, inclusion: { in: Months::LIST, allow_nil: true }
  validates :month_finished, inclusion: { in: Months::LIST, allow_nil: true }
  validate :year_started_before_year_finished

  def year_started_before_year_finished
    if year_started.present? && year_finished.present? && (year_finished < year_started)
      errors[:year_started] << 'must be before the year finished'
    end
  end

end
