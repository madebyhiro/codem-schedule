class Transcoder
  class << self
    def schedule(opts)
      job  = opts[:job]
      host = opts[:host]

      if attrs = post("#{host.url}/jobs", :payload => job_to_json(job))
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
        Rails.logger.debug attrs.first.inspect
        begin
          opts = attrs.extract_options!
          opts.merge!({ :method => method, :url => url })
          opts.merge!({ :content_type => :json, :accept => :json, :timeout => 1 })
          response = RestClient::Request.execute(opts)
          JSON::parse response
        rescue Errno::ECONNREFUSED, SocketError, Errno::ENETUNREACH, Errno::EHOSTUNREACH, Errno::ETIMEDOUT, RestClient::Exception, JSON::ParserError
          false
        end
      end
  end
end
