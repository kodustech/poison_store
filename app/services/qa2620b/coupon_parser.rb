class CouponParser
  def parse(code)
    prefix, value = code.split("-")
    { kind: prefix, value: value.to_i }
  end
end
