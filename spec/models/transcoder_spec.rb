require File.dirname(__FILE__) + '/../spec_helper'

describe Transcoder, type: :model do
  describe 'scheduling a job' do
    before(:each) do
      @preset = FactoryGirl.create(:preset)
      @job    = FactoryGirl.create(:job, preset_id: @preset.id)
      @host   = FactoryGirl.create(:host)

      allow(Transcoder).to receive(:post)
    end

    def do_schedule
      Transcoder.schedule(job: @job, host: @host)
    end

    describe 'success' do
      before(:each) do
        allow(Transcoder).to receive(:post).and_return('foo' => 'bar')
      end

      it 'should return the correct attributes' do
        expect(do_schedule).to eq('host_id' => @host.id, 'foo' => 'bar')
      end
    end

    describe 'failed' do
      before(:each) do
        allow(Transcoder).to receive(:post).and_return false
      end

      it 'should remain in scheduled state' do
        do_schedule
        expect(@job.state).to eq(Job::Scheduled)
      end
    end

    it 'should convert a job to transcoder params correctly' do
      # with thumbnail options presetn
      expect(Transcoder.job_to_json(@job)).to eq({
        'source_file' => 'source',
        'destination_file' => 'dest',
        'encoder_options' => 'params',
        'thumbnail_options' => { 'seconds' => 1 }
      })

      # without thumbnail options
      @job.preset.thumbnail_options = nil
      expect(Transcoder.job_to_json(@job)).to eq({
        'source_file' => 'source',
        'destination_file' => 'dest',
        'encoder_options' => 'params',
        'thumbnail_options' => nil
      })
    end
  end

  describe "getting a host's status" do
    before(:each) do
      @host = FactoryGirl.create(:host)
      allow(Transcoder).to receive(:call_transcoder).and_return true
    end

    def do_get
      Transcoder.host_status(@host)
    end

    it 'should get the status' do
      expect(Transcoder).to receive(:call_transcoder).with(:get, 'url/jobs')
      expect(do_get).to eq(true)
    end
  end

  describe "getting a job's status" do
    before(:each) do
      @host = FactoryGirl.create(:host)
      @job  = FactoryGirl.create(:job, host_id: @host.id)
      allow(Transcoder).to receive(:call_transcoder).and_return true
    end

    def do_get
      Transcoder.job_status(@job)
    end

    it 'should get the status' do
      expect(Transcoder).to receive(:call_transcoder).with(:get, 'url/jobs/1')
      expect(do_get).to eq(true)
    end
  end

  describe 'POSTing to the transcoders' do
    before(:each) do
      allow(RestClient::Request).to receive(:execute).and_return '{"foo":"bar"}'
    end

    def do_post
      Transcoder.post('url',  'foo' => 'bar')
    end

    it 'should make the correct call' do
      args = { url: 'url', method: :post, payload: { 'foo' => 'bar' }.to_json }
      expect(RestClient::Request).to receive(:execute).with(hash_including(args))
      expect(do_post).to eq('foo' => 'bar')
    end

    [RestClient::Exception, Errno::ECONNREFUSED, SocketError, Errno::ENETUNREACH, JSON::ParserError].each do |ex|
      it "should recover from #{ex}" do
        allow(RestClient::Request).to receive(:execute).and_raise ex
        expect(do_post).to eq(false)
      end
    end
  end

  describe 'GETting from the transcoders' do
    before(:each) do
      allow(RestClient::Request).to receive(:execute).and_return '{"foo":"bar"}'
    end

    def do_get
      Transcoder.get('url',  'foo' => 'bar')
    end

    it 'should make the correct call' do
      args = { url: 'url', method: :get, payload: { 'foo' => 'bar' }.to_json }
      expect(RestClient::Request).to receive(:execute).with(hash_including(args))
      do_get
    end

    [RestClient::Exception, Errno::ECONNREFUSED, SocketError, Errno::ENETUNREACH, Errno::EHOSTUNREACH, JSON::ParserError].each do |ex|
      it "should recover from #{ex}" do
        allow(RestClient::Request).to receive(:execute).and_raise ex
        expect(do_get).to eq(false)
      end
    end
  end

  describe 'deleting a job' do
    before do
      @job = Job.new(host: Host.new(url: 'host'), remote_job_id: 'id')
    end

    def do_delete
      Transcoder.remove_job(@job)
    end

    it 'should do nothing if the job has no host' do
      @job.host = nil
      expect(Transcoder).not_to receive(:delete)
      do_delete
    end

    it 'should do nothing if the job has no remote_job_id' do
      @job.remote_job_id = nil
      expect(Transcoder).not_to receive(:delete)
      do_delete
    end

    it 'should delete the job from the transcoder' do
      expect(Transcoder).to receive(:delete).with('host/jobs/id')
      do_delete
    end

    it 'should delegate the method correctly' do
      expect(Transcoder).to receive(:call_transcoder).with(:delete, 'host/jobs/id')
      do_delete
    end
  end

  describe 'probing' do
    before do
      @host = FactoryGirl.create(:host)
      allow(Host).to receive(:with_available_slots).and_return [@host]

      allow(RestClient::Request).to receive(:execute).and_return 'probe_results'
      allow(JSON).to receive(:parse).with('probe_results').and_return 'json'
    end

    def probe
      Transcoder.probe('movie.mp4')
    end

    it 'should find a host with available slots' do
      expect(Host).to receive(:with_available_slots).and_return [@host]
      probe
    end

    it 'should delegate the method correctly' do
      args = { method: :post, url: 'url/probe', payload: { source_file: 'movie.mp4' }.to_json }
      expect(RestClient::Request).to receive(:execute).with(hash_including(args))
      probe
    end

    it 'should return the probe results' do
      expect(probe).to eq('json')
    end

    it 'should return the exception if any occurrs' do
      e = StandardError.new('error')
      allow(RestClient::Request).to receive(:execute).and_raise(e)
      expect(probe).to eq(e)
    end
  end
end
