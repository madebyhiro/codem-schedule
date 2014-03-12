require 'spec_helper'

describe Api::ApiController do
  describe "GET 'probe'" do
    before(:each) do
      Transcoder.stub(:probe).and_return 'results'
    end

    def do_get
      get 'probe', source_file: 'foo', format: 'json'
    end

    it 'should probe using the transcoder' do
      Transcoder.should_receive(:probe).with('foo').and_return 'results'
      do_get
    end
  end
end

