require 'spec_helper'

describe JobsController, type: :controller do
  describe "GET 'index'" do
    before(:each) do
      @job = double(Job)
      allow(Job).to receive(:recents).and_return [@job]
      allow(History).to receive(:new).and_return 'history'
    end

    def do_get
      get 'index', period: 'period'
    end

    it 'should generate the correct history' do
      expect(History).to receive(:new).with('period')
      do_get
    end

    it 'should assign the history for the view' do
      do_get
      expect(assigns[:history]).to eq('history')
    end

    it 'should find the recent jobs' do
      expect(Job).to receive(:recents)
      do_get
    end

    it 'should assign the recent jobs for the view' do
      do_get
      expect(assigns[:jobs]).to eq([@job])
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @job = double(Job)
      allow(Job).to receive(:find).and_return @job
    end

    def do_get
      get 'show', id: 1
    end

    it 'should find the jobs' do
      expect(Job).to receive(:find).and_return @job
      do_get
    end

    it 'should assign the job for the view' do
      do_get
      expect(assigns[:job]).to eq(@job)
    end
  end

  describe "GET 'new'" do
    before(:each) do
      @job = double(Job)
      allow(Job).to receive(:new).and_return @job
    end

    def do_get
      get 'new'
    end

    it 'should generate a new job' do
      expect(Job).to receive(:new)
      do_get
    end

    it 'should assign the job for the view' do
      do_get
      expect(assigns[:job]).to eq(@job)
    end
  end
end
