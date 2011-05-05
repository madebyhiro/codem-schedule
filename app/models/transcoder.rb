class Transcoder
  class << self
    def schedule(opts)
      job  = opts[:job]
      host = opts[:host]

      attrs = post("#{host.url}/jobs", job_to_json(job))

      if attrs
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
        'callback_urls' => [callback_url(job)]
      }.to_json
    end
    
    def host_status(host)
      call_transcoder(:get, "#{host.url}/jobs")
    end

    def job_status(job)
      call_transcoder(:get, "#{job.host.url}/jobs/#{job.remote_job_id}")
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

      def callback_url(job)
        [job.callback_url, job.to_param].join('/')
      end
  end
end
