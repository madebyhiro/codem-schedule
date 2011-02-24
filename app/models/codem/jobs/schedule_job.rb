module Codem
  module Jobs
    class ScheduleJob < Codem::Jobs::Base
      def perform
        job_attrs = job_attributes_for_enqueue(job)

        available_hosts.each do |host|
          if attributes = try_to_queue(host, job_attrs)
            job.update_attributes :host_id => host.id
            job.enter(:queued, attributes)
            return true
          end
        end
        
        reschedule :run_at => 5.seconds.from_now
      end
      
      def available_hosts
        Host.with_available_slots
      end
      
      def try_to_queue(host, job_attrs)
        response = ScheduleJob.post("#{host.address}/jobs", :body => job_attrs.to_json)
        response.code == 202 ? response : false
      end
      
      private
        def job_attributes_for_enqueue(job)
          {
            'source_file' => job.source_file,
            'destination_file' => job.destination_file,
            'encoder_options' => job.preset.parameters
          }
        end
    end
  end
end