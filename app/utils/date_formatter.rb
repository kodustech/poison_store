module DateFormatter
  def format_date(date)
    return '-' if date.nil?
    date.strftime('%d/%m/%Y')
  end
end 