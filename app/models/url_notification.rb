class UrlNotification < Notification
  def do_notify!(opts)
    Net::HTTP::post_form(URI.parse(self.value), opts[:job].attributes)
  end
end
