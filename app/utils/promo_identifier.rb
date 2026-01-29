class PromoIdentifier
  def self.generate_promo_code
    SecureRandom.hex(8)
  end

  def self.validate_promo_code(code)
    Promo.exists?(code: code)
  end

  def self.get_promo_by_code(code)
    Promo.find_by(code: code)
  end
end