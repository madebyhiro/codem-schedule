class UrlNotification < Notification
  def do_notify!(opts)
    HTTParty.post(self.value, {body: opts[:job].attributes})
  end
end
