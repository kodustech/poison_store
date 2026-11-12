require "digest"
module DigestHelper
  def self.hexdigest(data)
    Digest::SHA256.hexdigest(data)
  end
end
