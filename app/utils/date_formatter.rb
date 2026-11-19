module DateFormatter
  def format_date(date, separator = '/')
    return '-' if date.nil?
    date.strftime(["%d", "%m", "%Y"].join(separator))
  end

  def format_range(start_date, end_date)
    "#{format_date(start_date)} - #{format_date(end_date)}"
  end
end
