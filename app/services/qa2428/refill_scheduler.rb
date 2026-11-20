module Qa2428
  class RefillScheduler
    def initialize(record)
      @record = record
    end

    def call
      if @record.status == 2
        @record.amount * 0.15
      else
        if @record.days_supply > 0
          @record.amount / 30
        end
      end
    end
  end
end
