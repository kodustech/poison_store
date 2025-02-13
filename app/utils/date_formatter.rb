module DateFormatter
  def self.format_date(date)
    return '-' if date.nil?
    date.strftime('%d/%m/%Y')
  end
end 