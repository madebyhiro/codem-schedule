module Codem
  Scheduled   = 'scheduled'
  Transcoding = 'transcoding'
  OnHold      = 'on_hold'
  Completed   = 'complete'
  Failed      = 'failed'

  module Base
    def self.included(base)
      base.class_eval do
        include States
        include Notifiers
      end
    end
  end
end