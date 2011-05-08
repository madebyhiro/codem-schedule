class EmailNotification < Notification
  def do_notify!(opts)
    Emailer.state_change(:job => opts[:job], 
                         :state => opts[:state], 
                         :to => self.value).deliver
  end
end
