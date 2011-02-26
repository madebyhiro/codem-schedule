module Codem
  module Notifiers
    class Email
      def initialize(mailer)
        @mailer = mailer
      end
      
      def notify(state, job)
        if @mailer.respond_to?(state)
          @mailer.send(state, job).deliver
        end
      end
    end
  end
end