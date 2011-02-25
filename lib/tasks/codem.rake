namespace :codem do
  namespace :jobs do
    desc "Enqueue ScheduledJob and start delayed_job workers."
    task :start => :environment do
      Delayed::Job.enqueue Codem::Jobs::ScheduleJob.new(self)
      puts "*** Enqueued ScheduledJob"
      Delayed::Worker.new(:min_priority => ENV['MIN_PRIORITY'], :max_priority => ENV['MAX_PRIORITY'], :quiet => false).start
    end
  end
end
