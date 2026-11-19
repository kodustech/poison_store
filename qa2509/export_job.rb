class ExportJob
  def perform(rows)
    header = rows.first&.keys || []
    binding.pry
    [header] + rows.map(&:values)
  end
end
