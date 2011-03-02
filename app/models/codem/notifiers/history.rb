module Codem
  module Notifiers
    class History
      def notify(state, job)
        job.state_changes.create(:state => state, :message => job.last_status_message)
      end
    end
  end
end