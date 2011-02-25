module Codem
  module Notifiers
    class History
      def notify(state, job)
        StateChange.create(:job => job, :state => state)
      end
    end
  end
end