require 'spec_helper'

describe Preset, type: :model do
  describe 'generating a preset via the API' do
    it 'should map the attributes correctly' do
      Preset.from_api('name' => 'name', 'parameters' => 'params', 'thumbnail_options' => '{"seconds":1}', 'segment_time_options' => 10)
      p = Preset.last
      expect(p.name).to eq('name')
      expect(p.parameters).to eq('params')
      expect(p.thumbnail_options).to eq('{"seconds":1}')
      expect(p.segment_time_options).to eq('10')
    end
  end

  describe 'validations' do
    def valid_preset
      Preset.new.tap do |p|
        p.name = 'foo'
        p.parameters = 'bar'
      end
    end

    it 'should be valid with params and no thumb options' do
      expect(valid_preset).to be_valid
    end

    it 'should be valid with thumb options and no params' do
      p = valid_preset
      p.parameters = ''
      p.thumbnail_options = '{"seconds":1}'
      expect(p).to be_valid
    end

    it 'should not be valid without params and thumb options' do
      p = valid_preset
      p.parameters = nil
      p.thumbnail_options = nil
      expect(p).not_to be_valid
    end

    it 'should not be valid with non-JSON thumbnail options' do
      p = valid_preset
      p.thumbnail_options = 'foo'
      expect(p).not_to be_valid
      expect(p.errors[:thumbnail_options]).to eq(['must be valid JSON'])
    end

    it 'should be valid with integer segment time options' do
      p = valid_preset
      p.segment_time_options = 10
      expect(p).to be_valid
    end

    it 'should not be valid with non-integer segment time options' do
      p = valid_preset
      p.segment_time_options = '{"segment_time": 10}'
      expect(p).to_not be_valid
      expect(p.errors[:segment_time_options]).to eq(['is not a number'])
    end
  end
end
