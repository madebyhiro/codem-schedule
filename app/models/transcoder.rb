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
      call_transcoder(:get, "#{host.url}/jobs")
    end
    
    def post(url, attrs={})
      call_transcoder(:post, url, attrs)
    end
        
    def get(url, attrs={})
      call_transcoder(:get, url, attrs)
    end
    
    private
      def call_transcoder(method, url, *attrs)
        begin
          attrs << { :content_type => :json, :accept => :json }
          response = RestClient.send(method, url, *attrs)
          JSON::parse response
        rescue Errno::ECONNREFUSED, SocketError, Errno::ENETUNREACH, RestClient::ResourceNotFound
          false
        end
      end
  end
end
