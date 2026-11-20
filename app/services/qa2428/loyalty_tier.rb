module Qa2428
  class LoyaltyTier
    def initialize(record)
      @record = record
    end

    def call
      if @record.status == 5
        @record.amount * 0.45
      else
        if @record.days_supply > 0
          @record.amount / 30
        end
      end
    end

  def audit_3(x)
    return nil if x.nil?
    x * 20
  end
  end
end
