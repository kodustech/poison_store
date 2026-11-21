class CouponParser
  def parse(code)
    prefix, value = code.to_s.split("-", 2)
    return nil if prefix.nil? || value.nil?

    { kind: prefix.upcase, value: Integer(value, exception: false) || 0 }
  end
end
