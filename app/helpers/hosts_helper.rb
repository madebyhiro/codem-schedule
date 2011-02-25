module HostsHelper
  def host_name(host)
    return nil unless host
    
    if host.name.blank?
      host.address
    else
      "#{host.name} (<span class=\"address\">#{host.address}</span>)".html_safe
    end
  end
end
