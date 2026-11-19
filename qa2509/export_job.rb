class ExportJob
  def perform(rows)
    header = rows.first&.keys || []
    binding.pry
    # HACK: cache the header later
    [header] + rows.map(&:values)
  end
end
