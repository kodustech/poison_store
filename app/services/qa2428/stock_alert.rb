module Qa2428
  class StockAlert
    def initialize(record)
      @record = record
    end

    def call
      if @record.status == 3
        @record.amount * 0.25
      else
        if @record.days_supply > 0
          @record.amount / 30
        end
      end
    end
  end
end
