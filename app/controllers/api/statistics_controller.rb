# = Statistics Controller
#
# This controller provides a basic statistics overview of jobs handled by the Scheduler
class Api::StatisticsController < Api::ApiController
  # == Show statistics for a given period
  #
  # === Parameters:
  # <tt>period</tt>:: The period to calculate the statistics for. Possible values are: <tt>today, yesterday, week, month,all</tt>. Default is <tt>today</tt>
  #
  # === Example:
  #   $ curl http://localhost:3000/api/statistics?period=week
  #
  #   {
  #     number_of_failed_jobs: 0
  #     average_processing_time: 8.244175910949707
  #     number_of_completed_jobs: 1
  #     average_queue_time: 1
  #     number_of_processing_jobs: 0
  #     seconds_encoded: 18
  #   }
  def show
    respond_with History.new(params[:period])
  end
end
