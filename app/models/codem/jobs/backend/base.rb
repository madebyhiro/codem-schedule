module Codem
  module Jobs
    module Backend
      module Base
        def self.included(base)
          base.extend ClassMethods
        end
        
        module ClassMethods
          attr_accessor :backend
          
          def initialize_backend
            backend = Backend::DelayedJob.new
          end
          
          def backend
            @backend ||= initialize_backend
          end
          
          def queue(background_job, options={})
            backend.enqueue background_job, options
          end
        end
      end
    end
  end
end
