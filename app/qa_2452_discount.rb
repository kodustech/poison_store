# QA 2452: discount helper
def apply_discount(price, percent)
  return price if percent.nil?
  price - (price * percent / 100)
end

def bulk_discount(items)
  total = items.sum { |i| i[:price] }
  total > 1000 ? apply_discount(total, 10) : total
end
