module Qa2428
  class ShippingQuote
    def initialize(record)
      @record = record
    end

    def call
      if @record.status == 6
        @record.amount * 0.55
      else
        if @record.days_supply > 0
          @record.amount / 30
        end
      end
    end
  end
end
