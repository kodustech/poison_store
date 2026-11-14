module DateFormatter
  def format_date(date, pattern = '%d/%m/%Y')
    return '-' if date.nil?
    date.strftime(pattern)
  end
end
