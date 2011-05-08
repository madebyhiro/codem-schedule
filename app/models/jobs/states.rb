module Jobs
  module States
    def self.included(base)
      base.class_eval do
        include ActiveModel::Dirty
        after_initialize :set_initial_state
      end
    end
    
    def initial_state
      Job::Scheduled
    end
    
    def enter(state, params={})
      self.state = state

      if state_changed?
        add_state_change(:state => state, :message => params['message'])
      end
      save
      
      self.send("enter_#{state}", params)
      self
    end
    
    def add_state_change(attrs)
      self.state_changes.build(attrs)
    end
    
    protected
      def set_initial_state
        self.state ||= Job::Scheduled
      end

      def enter_scheduled(params)
        for host in Host.with_available_slots
          if attrs = Transcoder.schedule(:host => host, :job => self)
            enter(Job::Accepted, attrs)
          end
        end
      end

      def enter_accepted(params)
        update_attributes :host_id => params['host_id'],
                          :remote_job_id => params['job_id'],
                          :transcoding_started_at => Time.current
      end
      
      def enter_processing(params)
        update_attributes :progress => params['progress'],
                          :duration => params['duration'],
                          :filesize => params['filesize']
      end
      
      def enter_on_hold(params)
        
      end
      
      def enter_failed(params)
        update_attributes :message => params['message']
        notify
      end
      
      def enter_success(params)
        update_attributes :completed_at => Time.current,
                          :message => params['message'],
                          :progress => 1.0
        notify
      end
      
      def notify
        notifications.each { |n| n.notify!(:job => self, :state => state) }
      end
      
      def all_notifications
        (self.notification + self.preset.notifications).uniq
      end
  end
end
