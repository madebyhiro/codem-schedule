namespace :codem do
  namespace :jobs do
    desc "Start delayed_job workers."
    task :start => :environment do
      Delayed::Worker.new(:min_priority => ENV['MIN_PRIORITY'], :max_priority => ENV['MAX_PRIORITY'], :quiet => false).start
    end
  end
end
