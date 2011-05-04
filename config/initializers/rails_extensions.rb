module ActionView
  module Helpers
    module NumberHelper
      def number_to_time(seconds)
        return nil if seconds.to_i == 0
        time = Time.gm(2000,1,1) + seconds.to_i
        Time.at(time).utc.strftime("%H:%M:%S")
      end
    end
  end
end
