module ScheduleStrategies
  class Weighted < Base
    def hosts
      Host.with_available_slots.tap do |hosts|
        hosts.sort! { |a,b| b.weight <=> a.weight }
        hosts.sort! { |a,b| b.available_slots <=> a.available_slots }
      end
    end
  end
end

