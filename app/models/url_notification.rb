class UrlNotification < Notification
  def do_notify!(opts)
    RestClient.post(value, opts[:job].attributes)
  end
end
