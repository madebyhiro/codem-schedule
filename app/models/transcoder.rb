class Transcoder
  class << self
    def schedule(opts)
      job  = opts[:job]
      host = opts[:host]

      if attrs = post("#{host.url}/jobs", job_to_json(job))
        attrs.merge('host_id' => host.id)
      else
        false
      end
    end
    
    def job_to_json(job)
      {
        'source_file' => job.source_file,
        'destination_file' => job.destination_file,
        'encoder_options' => job.preset.parameters,
        'thumbnail_options' => job.preset.thumbnail_options,
        'callback_urls' => [ job.callback_url ]
      }.to_json
    end
    
    def host_status(host)
      get "#{host.url}/jobs"
    end

    def job_status(job)
      if job.host.try(:url) && job.remote_job_id
        get "#{job.host.url}/jobs/#{job.remote_job_id}"
      end
    end
    
    def post(url, *attrs)
      call_transcoder(:post, url, *attrs)
    end
        
    def get(url, *attrs)
      call_transcoder(:get, url, *attrs)
    end
    
    private
      def call_transcoder(method, url, *attrs)
        begin
          attrs << { :content_type => :json, :accept => :json, :timeout => 2 }
          response = RestClient.send(method, url, *attrs)
          JSON::parse response
        rescue Errno::ECONNREFUSED, SocketError, Errno::ENETUNREACH, Errno::EHOSTUNREACH, RestClient::Exception, JSON::ParserError
          false
        end
      end
  end
end
