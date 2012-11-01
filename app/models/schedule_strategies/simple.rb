module ScheduleStrategies
  class Simple < Base
    def hosts
      Host.with_available_slots
    end
  end
end

