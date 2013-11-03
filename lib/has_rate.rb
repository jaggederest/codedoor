module HasRate
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

  def client_rate_text
    rate_text(daily_rate_to_client)
  end

  def programmer_rate_text
    rate_text(daily_rate_to_programmer)
  end

  private

  def rate_text(rate)
    case availability
    when 'part-time'
      "$#{rate} / 8 hours"
    when 'full-time'
      "$#{rate} / day"
    else
      'Unavailable'
    end
  end

end
