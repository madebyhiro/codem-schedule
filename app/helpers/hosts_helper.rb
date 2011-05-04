module HostsHelper
  def host_name(host)
    return nil unless host
    
    if host.name == ''
      host.url
    else
      "#{host.name} (<span class=\"address\">#{host.url}</span>)".html_safe
    end
  end
end
