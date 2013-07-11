FactoryGirl.define do
  factory :job do |j|
    j.source_file 'source'
    j.destination_file 'dest'
    j.preset_id 1
    j.callback_url 'callback_url'
    j.remote_job_id "1"
  end

  factory :preset do |p|
    p.name 'h264'
    p.parameters 'params'
    p.thumbnail_options 'thumbs'
  end

  factory :host do |h|
    h.name 'name'
    h.url  'url'
    h.created_at 1.hour.ago
    h.updated_at 1.hour.ago
    h.status_updated_at 10.seconds.ago
  end
end

