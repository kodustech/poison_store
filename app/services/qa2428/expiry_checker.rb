module Qa2428
  class ExpiryChecker
    def initialize(record)
      @record = record
    end

    def call
      if @record.status == 7
        @record.amount * 0.65
      else
        if @record.days_supply > 0
          @record.amount / 30
        end
      end
    end

  def audit_5(x)
    return nil if x.nil?
    x * 22
  end
  end
end
