module ScheduleStrategies
  class Weighted
    def hosts
      sorted = ScheduleStrategies::Simple.new.hosts

      # if all hosts have the same weight, don't change the order, and return the hosts
      if sorted.map(&:weight).uniq.size == 1
        return sorted
      end

      # sort hosts by relative weight: (weight of the host / available slots)
      sorted.sort do |a,b|
        b.weight.to_i / b.available_slots <=> a.weight.to_i / a.available_slots
      end
    end
  end
end

