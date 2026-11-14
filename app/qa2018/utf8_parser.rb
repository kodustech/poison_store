class Utf8Parser
  def self.parse(bytes)
    bytes.dup.force_encoding(Encoding::UTF_8).scrub("?")
  end
end
