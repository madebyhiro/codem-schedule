require 'spec_helper'

describe Preset, type: :model do
  describe 'generating a preset via the API' do
    it 'should map the attributes correctly' do
      Preset.from_api('name' => 'name', 'parameters' => 'params',
                      'thumbnail_options' => '{"seconds":1}',
                      'segments_options' => '{"segment_time":10}')
      p = Preset.last
      expect(p.name).to eq('name')
      expect(p.parameters).to eq('params')
      expect(p.thumbnail_options).to eq('{"seconds":1}')
      expect(p.segments_options).to eq('{"segment_time":10}')
    end
  end

  describe 'validations' do
    it 'should be valid with params and no thumb options' do
      p = Preset.new
      p.name = 'foo'
      p.parameters = 'bar'
      p.thumbnail_options = ''
      expect(p).to be_valid
    end

    it 'should be valid with thumb options and no params' do
      p = Preset.new
      p.name = 'foo'
      p.parameters = ''
      p.thumbnail_options = '{"seconds":1}'
      expect(p).to be_valid
    end

    it 'should not be valid without params and thumb options' do
      p = Preset.new
      p.name = 'foo'
      expect(p).not_to be_valid
    end

    it 'should not be valid with non-JSON thumbnail options' do
      p = Preset.new
      p.thumbnail_options = 'foo'
      expect(p).not_to be_valid
      expect(p.errors[:thumbnail_options]).to eq(['must be valid JSON'])
    end

    it 'should not be valid with segments options and thumb options and no params' do
      p = Preset.new
      p.name = 'foo'
      p.parameters = ''
      p.thumbnail_options = '{"seconds":1}'
      p.segments_options = '{"segment_time":10}'
      expect(p).not_to be_valid
    end

    it 'should not be valid with non-JSON segments options' do
      p = Preset.new
      p.name = 'foo'
      p.parameters = 'params'
      p.thumbnail_options = '{"seconds":1}'
      p.segments_options = 'foo'
      expect(p).not_to be_valid
    end
  end
end
