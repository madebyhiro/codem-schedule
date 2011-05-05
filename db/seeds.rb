%w(hosts jobs presets state_changes).each do |name|
  ActiveRecord::Base.connection.execute("TRUNCATE #{name}")
end

Host.create!(:url => 'http://127.0.0.1:8080', :name => "Localhost")

Preset.create!(:name => 'h264', :parameters => '-acodec libfaac -ab 96k -ar 44100 -vcodec libx264 -vb 416k -vpre slow -vpre baseline -s 320x180 -y')
