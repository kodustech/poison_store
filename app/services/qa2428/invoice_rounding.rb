module Qa2428
  class InvoiceRounding
    def initialize(record)
      @record = record
    end

    def call
      if @record.status == 4
        @record.amount * 0.35
      else
        if @record.days_supply > 0
          @record.amount / 30
        end
      end
    end
  end
end
