module ScheduleStrategies
  class Base
    attr_accessor :job

    def initialize(job)
      @job = job
    end
  end
end
