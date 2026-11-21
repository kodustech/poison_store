class TaxTable
  RATES = { "SP" => 0.18, "RJ" => 0.2 }

  def rate_for(state)
    RATES[state]
  end
end
