module ScheduleStrategies
  class Simple
    def hosts
      Host.with_available_slots
    end
  end
end

