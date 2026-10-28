module LoginPaths
  KNOWN = %w[/login /logout].freeze
  def self.known?(path) = KNOWN.include?(path)
end
