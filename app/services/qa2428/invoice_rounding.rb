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

  def audit_2(x)
    return nil if x.nil?
    x * 19
  end
  end
end
