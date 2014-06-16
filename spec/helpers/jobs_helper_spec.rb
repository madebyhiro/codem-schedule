require 'spec_helper'

describe JobsHelper, type: :helper do
  describe 'progress as percentage' do
    it 'should be correct' do
      expect(progress_as_percentage(0.4597)).to eq('45.97')
    end
  end

  it 'should return the correct encoding time' do
    job = double(Job, completed_at: 10, transcoding_started_at: '5')
    expect(encoding_time(job)).to eq(5)
  end

  it 'should return 0 for any weird encoding times' do
    job = double(Job, completed_at: nil, transcoding_started_at: 1)
    expect(encoding_time(job)).to eq(0)
  end

  describe 'destination filesize' do
    before(:each) do
      @job = double(Job, destination_file: 'foo')
    end

    def filesize
      destination_filesize(@job)
    end

    it 'should return the correct filesize' do
      expect(File).to receive(:size).with('foo').and_return 2_000
      expect(filesize).to eq(2_000)
    end

    it 'should handle missing files correctly' do
      allow(File).to receive(:size).and_raise Errno::ENOENT
      expect(filesize).to eq('unknown (file gone)')
    end
  end

  describe 'notification dates' do
    before(:each) do
      @job = double(Job, completed_at: 10)
      @not = double(Notification, notified_at: 20)
    end

    def notify
      notified_at @not, @job
    end

    it 'should return the correct number' do
      expect(notify).to eq('00:00:10')
    end

    it 'should handle not sent notifications' do
      allow(@not).to receive(:notified_at).and_return nil
      expect(notify).to eq(nil)
    end
  end

  it 'should return the correct compression rate' do
    allow(File).to receive(:size).with('/foo').and_return 1_000
    job = double(Job, filesize: 2_000, destination_file: '/foo')
    expect(compression_rate(job)).to eq('50.00')
  end

  describe 'number to time' do
    it 'should return nil if seconds < 1' do
      expect(number_to_time(0.5)).to eq(nil)
    end

    it 'should return the correct string' do
      expect(number_to_time(13_762)).to eq('03:49:22')
    end

    it 'should be correct for times > 1 day' do
      expect(number_to_time(95_099)).to eq('01:02:24:59')
    end
  end
end
