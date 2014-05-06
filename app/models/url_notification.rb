class UrlNotification < Notification
  def do_notify!(opts)
    RestClient.post(self.value, opts[:job].attributes)
  end
end
