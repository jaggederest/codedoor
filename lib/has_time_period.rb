module HasTimePeriod
  extend ActiveSupport::Concern

  included do
    validates :month_started, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
    validates :month_finished, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 12, allow_nil: true }
    validates :month_finished, presence: true, unless: Proc.new{|r| r.is_current?}
    validates :year_started, numericality: { greater_than: 1900, less_than: 2014 }
    validates :year_finished, numericality: { greater_than: 1900, less_than: 2014, allow_nil: true}
    validates :year_finished, presence: true, unless: Proc.new{|r| r.is_current?}
    validate :started_before_finished

    before_save :remove_finished_date, if: Proc.new{|r| r.is_current?}
  end

  def started_before_finished
    if !is_current? && dates_filled_in
      if year_finished < year_started
        errors.add(:year_started, 'must be before the year finished')
      elsif (year_finished == year_started) && (month_finished < month_started)
        errors.add(:month_started, 'must be before month finished when the year is the same')
      end
    end
  end

  def remove_finished_date
    self.month_finished = nil
    self.year_finished = nil
  end

  private

  def dates_filled_in
    year_started.present? && year_finished.present? && month_started.present? && month_finished.present?
  end

end
