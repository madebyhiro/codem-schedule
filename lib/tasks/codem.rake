namespace :codem do
  namespace :jobs do
    desc "Enqueue only *one* ScheduleJob"
    task :enqueue_schedule_job => :environment do
      Codem::Jobs::ScheduleJob.ensure_only_one_instance_running!
      Delayed::Job.enqueue Codem::Jobs::ScheduleJob.new
      puts "*** Enqueued ScheduledJob"
    end
    
    desc "Enqueue ScheduledJob and start delayed_job workers."
    task :start => :enqueue_schedule_job do
      Delayed::Worker.new(:min_priority => ENV['MIN_PRIORITY'], :max_priority => ENV['MAX_PRIORITY'], :quiet => false).start
    end
  end
end
