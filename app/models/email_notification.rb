class EmailNotification < Notification
  def notify!(opts)
    Emailer.state_change(:job => opts[:job], 
                         :state => opts[:state], 
                         :to => self.value).deliver
  end
end
