module Codem
  module Jobs
    class ScheduleJob < Codem::Jobs::Base
      def self.ensure_only_one_instance_running!
        Delayed::Job.all.each do |job|
          job.destroy if job.payload_object.is_a?(Codem::Jobs::ScheduleJob)
        end
      end
      
      def perform
        if scheduled_jobs.any?
          for host in available_hosts
            next unless schedule_jobs_at(host)
          end
        end
        reschedule unless scheduled_jobs.empty?
      end

      def schedule_jobs_at(host)
        scheduled_jobs.each do |job|
          if attributes = try_to_queue(host, job)
            job.update_attributes :host_id => host.id
            job.enter(:queued, attributes)
          else
            return false
          end
        end
      end

      def available_hosts
        Host.with_available_slots
      end

      def scheduled_jobs
        Job.scheduled
      end

      def try_to_queue(host, job)
        response = ScheduleJob.post("#{host.address}/jobs", :body => job_attributes_for_enqueue(job))
        response.code == 202 ? response : false
      end

      protected
        def job_attributes_for_enqueue(job)
          {
            'source_file' => job.source_file,
            'destination_file' => job.destination_file,
            'encoder_options' => job.preset.parameters,
            'callback_urls' => ["http://10.0.2.8:3000/jobs/#{job.id}"]
          }.to_json
        end

    end
  end
end
