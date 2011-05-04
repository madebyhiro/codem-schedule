class Transcoder
  class << self
    def schedule(opts)
      job  = opts[:job]
      host = opts[:host]

      attrs = post("#{host.url}/jobs", job_to_json(job))

      if attrs
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

    def status(host)
      get("#{host.url}/jobs")
    end
    
    def post(url, attrs)
      send(:post, url, attrs)
    end
        
    def get(url, attrs)
      send(:get, url, attrs)
    end
    
    private
      def send(method, url, attrs)
        begin
          response = RestClient.send(method, url, attrs, :content_type => :json, :accept => :json)
          JSON::parse response
        rescue Errno::ECONNREFUSED, SocketError, Errno::ENETUNREACH
          false
        end
      end
  end
end
