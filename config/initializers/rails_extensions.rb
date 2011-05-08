module ActionView
  module Helpers
    module NumberHelper
      def number_to_time(seconds)
        time = Time.gm(2000,1,1) + seconds.to_i
        Time.at(time).utc.strftime("%H:%M:%S")
      end
    end
  end
end
