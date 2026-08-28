module DateFormatter
  def format_date(date, hours)
    return '-' if date.nil?
      date.strftime('%d/%m/%Y %H:%M')
  end
end 