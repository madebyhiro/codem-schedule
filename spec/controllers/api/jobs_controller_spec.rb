require 'spec_helper'

describe Api::JobsController, :type => :controller do
  before(:each) do
    @preset = FactoryGirl.create(:preset)
  end

  describe "POST 'create'" do
    describe "valid request" do
      def do_post(format=:json)
        post "create", :input => 'input', :output => 'output', :preset => 'h264', :format => format
      end
    
      it "creates jobs" do
        do_post

        job = Job.last
        expect(job.source_file).to eq('input')
        expect(job.destination_file).to eq('output')
        expect(job.preset.name).to eq('h264')
      end

      it "should set the state changes header" do
        do_post
        expect(response.headers['X-State-Changes-Location']).to eq(api_state_changes_url(Job.last))
      end
      
      it "should set the notifications header" do
        do_post
        expect(response.headers['X-Notifications-Location']).to eq(api_notifications_url(Job.last))
      end
      
      it "should redirect to /jobs if :html" do
        do_post(:html)
        expect(response).to redirect_to(jobs_path)
      end
    end
    
    describe "invalid request" do
      def do_post(format=:json)
        post "create", :input => 'input', :preset => 'h264', :format => format
      end
      
      it "should not create jobs" do
        expect { do_post }.not_to change(Job, :count)
      end
      
      it "should render /jobs/new if :html" do
        do_post(:html)
        expect(response).to render_template(:new)
      end
    end
  end
  
  describe "GET 'show'" do
    subject { FactoryGirl.create(:job) }

    before(:each) do
      allow(Job).to receive(:find).and_return subject
    end
    
    def do_get(format=:json)
      get 'show', :id => subject.id, :format => format
    end
    
    it "shows a job as JSON" do
      do_get(:json)
      expect(response.body).to eq(subject.to_json)
    end

    it "shows a job as XML" do
      do_get(:xml)
      expect(response.body).to eq(subject.to_xml)
    end
  end
  
  describe "PUT 'update'" do
    subject { FactoryGirl.create(:job) }

    before(:each) do
      allow(Job).to receive(:find).and_return subject
      allow(subject).to receive(:enter_status)
    end
    
    def do_put
      put 'update', :id => subject.id, :status => 'status', format: 'json'
    end
    
    it "should find the job" do
      expect(Job).to receive(:find).with(subject.id.to_s)
      do_put
    end
    
    it "should enter the correct state" do
      allow(request).to receive(:headers).and_return 'headers'

      expect(subject).to receive(:enter).with(
        'status', 
        {"status"=>"status", "id"=>subject.id.to_s, "format"=>"json", "controller"=>"api/jobs", "action"=>"update"},
        'headers'
      )
      do_put
    end
  end
  
  describe "GET 'index'" do
    subject { FactoryGirl.create(:job) }
    
    def do_get(format)
      get 'index', :format => format
    end
    
    it "shows jobs as JSON" do
      do_get(:json)
      expect(response.body).to eq(Job.all.to_json)
    end
    
    it "shows jobs as XML" do
      do_get(:xml)
      expect(response.body).to eq(Job.all.to_xml)
    end
  end
  
  describe "GET 'scheduled'" do
    subject { FactoryGirl.create(:job) }

    before(:each) do
      subject.update_attributes(:state => Job::Scheduled)
    end
    
    def do_get(format)
      get 'scheduled', :format => format
    end
    
    it "shows scheduled jobs as JSON" do
      do_get(:json)
      expected = JSON.load(subject.to_json)
      actual   = JSON.load(response.body).first
      expect(expected.slice(:created_at, :updated_at)).to eq(actual.slice(:created_at, :updated_at))
    end
    
    it "shows scheduled jobs as XML" do
      do_get(:xml)
      expect(response.body).to eq([subject].to_xml)
    end
  end

  describe "GET 'processing'" do
    subject { FactoryGirl.create(:job) }

    before(:each) do
      subject.update_attributes(:state => Job::Processing)
      Job.stub_chain(:processing, :order, :page).and_return [subject]
    end
    
    def do_get(format)
      get 'processing', :format => format
    end
    
    it "shows processing jobs as JSON" do
      do_get(:json)
      expect(response.body).to eq([subject].to_json)
    end
    
    it "shows processing jobs as XML" do
      do_get(:xml)
      expect(response.body).to eq([subject].to_xml)
    end
  end
  
  describe "GET 'on_hold'" do
    subject { FactoryGirl.create(:job) }

    before(:each) do
      subject.update_attributes(:state => Job::OnHold)
      Job.stub_chain(:on_hold, :order, :page).and_return [subject]
    end
    
    def do_get(format)
      get 'on_hold', :format => format
    end
    
    it "shows on hold jobs as JSON" do
      do_get(:json)
      expect(response.body).to eq([subject].to_json)
    end
    
    it "shows on hold jobs as XML" do
      do_get(:xml)
      expect(response.body).to eq([subject].to_xml)
    end
  end

  describe "GET 'success'" do
    subject { FactoryGirl.create(:job) }

    before(:each) do
      subject.update_attribute(:state, Job::Success)
    end
    
    def do_get(format)
      get 'success', :format => format
    end
    
    it "shows success jobs as JSON" do
      do_get(:json)
      expected = JSON.load(subject.to_json)
      actual   = JSON.load(response.body).first
      expect(expected.slice(:created_at, :updated_at)).to eq(actual.slice(:created_at, :updated_at))
    end
    
    it "shows success jobs as XML" do
      do_get(:xml)
      expect(response.body).to eq([subject].to_xml)
    end
  end

  describe "GET 'failed'" do
    subject { FactoryGirl.create(:job) }

    before(:each) do
      subject.update_attributes(:state => Job::Failed)
    end
    
    def do_get(format)
      get 'failed', :format => format
    end
    
    it "shows failed jobs as JSON" do
      do_get(:json)
      expected = JSON.load(subject.to_json)
      actual   = JSON.load(response.body).first
      expect(expected.slice(:created_at, :updated_at)).to eq(actual.slice(:created_at, :updated_at))
    end
    
    it "shows failed jobs as XML" do
      do_get(:xml)
      expect(response.body).to eq([subject].to_xml)
    end
  end
  
  describe "DELETE 'purge'" do
    subject { FactoryGirl.create(:job) }

    before(:each) do
      subject.update_attributes(:state => Job::Failed)
    end
    
    def do_delete
      delete 'purge'
    end
    
    it "should delete all failed jobs" do
      do_delete
      expect(Job.count).to eq(0)
    end
    
    it "should render nothing" do
      do_delete
      expect(response.body).to eq(' ')
    end
  end

  describe "POST 'retry'" do
    subject { double(Job, :enter => true) }

    before(:each) do
      allow(Job).to receive(:find).and_return subject
    end
    
    def do_post
      post "retry", :id => 1
    end
    
    it "should find the job" do
      expect(Job).to receive(:find).with('1')
      do_post
    end
    
    it "should set the state to scheduled" do
      expect(subject).to receive(:enter).with(Job::Scheduled)
      do_post
    end
    
    it "should redirect to the index" do
      do_post
      expect(response).to redirect_to(jobs_path)
    end
  end

  describe "DELETE 'destroy'" do
    subject { double(Job, :destroy => true) }

    before(:each) do
      allow(Job).to receive(:find).and_return subject
    end

    def do_delete
      delete "destroy", :id => 1
    end

    it "should delete the job" do
      expect(subject).to receive(:destroy)
      do_delete
    end

    it "should redirect to the index" do
      do_delete
      expect(response).to redirect_to(jobs_path)
    end
  end
end
