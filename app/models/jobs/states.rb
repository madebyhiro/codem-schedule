module Jobs
  module States
    def self.included(base)
      base.class_eval do
        before_create :set_initial_state
        after_create :create_initial_state_change
      end
    end

    def initial_state
      Job::Scheduled
    end

    def enter(new_state, params = {}, _headers = {})
      with_lock(true) do
        if state != new_state
          self.state = new_state

          create_state_change(params['message'])

          send("enter_#{new_state}", params)
          save
        end
      end

      self
    end

    def create_state_change(message = nil)
      state_changes.create!(state: state, message: message)
    end

    protected

    def set_initial_state
      self.state = initial_state
    end

    def create_initial_state_change
      create_state_change
    end

    def enter_scheduled(_params)
    end

    def enter_processing(params)
      update_attributes progress: params['progress'],
                        duration: params['duration'],
                        filesize: params['filesize']
      notify
    end

    def enter_on_hold(_params)
    end

    def enter_failed(params)
      update_attributes message: params['message']
      notify
    end

    def enter_success(params)
      update_attributes(
        completed_at: Time.current,
        message:      params['message'],
        thumbnails:   params['thumbnails'],
        playlist:     params['playlist'],
        segments:     params['segments'],
        progress:     1.0
      )
      notify
    end

    def notify
      notifications.each { |n| n.notify!(job: self, state: state) }
    end
  end
end
