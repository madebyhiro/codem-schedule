%w(hosts statuses jobs presets).each do |name|
  ActiveRecord::Base.connection.execute("TRUNCATE #{name}")
end

#Host.create!(:address => 'http://10.0.2.1:8080', :name => "Sjoerd's Mac", :available => true)
Host.create!(:address => 'http://127.0.0.1:8080', :name => "Localhost", :available => true)
Host.create!(:address => 'http://127.0.0.1:9999', :name => "Localhost", :available => false)

Preset.create!(:name => 'h264', :parameters => 'params')

50.times do |i|
  Job.create!({
    :source_file => "/e/ap/download/insane/path/job_#{i}.mkv",
    :destination_file => "/e/ap/download/insane/path/job_#{i}.mp4",
    :created_at => (i+1).hours.ago,
    :preset => Preset.first
  })
end
