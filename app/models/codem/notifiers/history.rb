module Codem
  module Notifiers
    class History
      def notify(state, job)
        job.state_changes.create(:state => state)
      end
    end
  end
end