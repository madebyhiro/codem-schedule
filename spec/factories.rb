Factory.define :job do |j|
  j.source_file 'source'
  j.destination_file 'dest'
  j.preset_id 1
  j.callback_url 'callback_url'
  j.remote_job_id "1"
end

Factory.define :preset do |p|
  p.name 'h264'
  p.parameters 'params'
end

Factory.define :host do |h|
  h.name 'name'
  h.url  'url'
  h.updated_at 1.hour.ago
end