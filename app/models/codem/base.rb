module Codem
  module Base
    def self.included(base)
      base.class_eval do
        include States
        include Notifiers
      end
    end
  end
end