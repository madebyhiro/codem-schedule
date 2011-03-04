module Codem
  module Jobs
    class ScheduleJob < Codem::Jobs::Base
      def perform
        for host in available_hosts
          return if schedule_job_at(host, job)
        end
        reschedule
      end

      def schedule_job_at(host, job)
        if attributes = try_to_queue(host, job)
          job.update_attributes :host_id => host.id
          job.enter(Codem::Transcoding, attributes)
        else
          return false
        end
      end

      def try_to_queue(host, job)
        begin
          response = ScheduleJob.post("#{host.address}/jobs", :body => job_attributes_for_enqueue(job))
          response.code == 202 ? response : false
        rescue Errno::ECONNREFUSED
          false
        end
      end

      def available_hosts
        Host.with_available_slots
      end

      def scheduled_jobs
        Job.scheduled
      end

      protected
        def job_attributes_for_enqueue(job)
          {
            'source_file' => job.source_file,
            'destination_file' => job.destination_file,
            'encoder_options' => job.preset.parameters,
            'callback_urls' => ["http://127.0.0.1:3000/jobs/#{job.id}"]
          }.to_json
        end

    end
  end
end
