class Transcoder
  class << self
    def schedule(opts)
      job  = opts[:job]
      host = opts[:host]

      response = post("#{host.url}/jobs", job_to_json(job))

      if response && response.code == 202
        attrs = JSON::parse(response)
        attrs.merge!('host_id' => host.id)
        job.enter(Job::Transcoding, attrs)
      else
        false
      end
    end
    
    def job_to_json(job)
      {
        'source_file' => job.source_file,
        'destination_file' => job.destination_file,
        'encoder_options' => job.preset.parameters,
        'callback_urls' => ["http://127.0.0.1:3000/api/jobs/#{job.id}"]
      }.to_json
    end
    
    def post(url, attrs)
      begin
        RestClient.post(url, attrs, :content_type => :json, :accept => :json)
      rescue Errno::ECONNREFUSED
        false
      end        
    end
  end
end
