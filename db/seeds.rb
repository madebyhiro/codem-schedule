%w(hosts jobs presets state_changes).each do |name|
  ActiveRecord::Base.connection.execute("TRUNCATE #{name}")
end

#Host.create!(:address => 'http://10.0.2.1:8080', :name => "Sjoerd's Mac")
Host.create!(:address => 'http://127.0.0.1:8080', :name => "Localhost")

Preset.create!(:name => 'h264', :parameters => '-acodec libfaac -ab 96k -ar 44100 -vcodec libx264 -vb 416k -vpre slow -vpre baseline -s 320x180 -y')

500.times do |i|
  Job.create!({
    :source_file => "/e/ap/download/insane/path/job_#{i}.mkv",
    :destination_file => "/e/ap/download/insane/path/job_#{i}.mp4",
    :created_at => i.minutes.ago,
    :preset => Preset.first
  })
end
