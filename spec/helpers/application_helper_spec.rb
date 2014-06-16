require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationHelper, type: :helper do
  it 'should set the title correctly' do
    expect(self).to receive(:content_for).with(:title)
    title('foo')
  end

  it 'should return a nice label' do
    expect(state_label('processing')).to eq('<span class="label label-warning">Processing</span>')
    expect(state_label('onhold')).to eq('<span class="label label-inverse">Onhold</span>')
    expect(state_label('success')).to eq('<span class="label label-success">Success</span>')
    expect(state_label('failed')).to eq('<span class="label label-important">Failed</span>')
    expect(state_label('moo')).to eq('<span class="label label-default">Moo</span>')
  end

  describe 'sortable' do
    before(:each) do
      params[:q] = 'q'
      allow(helper).to receive(:sort_column).and_return nil
      allow(helper).to receive(:sort_direction).and_return nil
      allow(helper).to receive(:link_to)
    end

    describe 'without a sorting' do
      it 'should return the correct link' do
        expect(helper).to receive(:link_to).with('The ID', { sort: 'id', direction: 'asc', q: 'q' },  class: nil)
        helper.sortable('id', 'The ID')
      end
    end

    describe 'with a sorting' do
      before(:each) do
        allow(helper).to receive(:sort_column).and_return 'mooh'
        allow(helper).to receive(:sort_direction).and_return 'asc'
      end

      it 'should return the correct link' do
        expect(helper).to receive(:link_to).with('Mooh', { sort: 'mooh', direction: 'desc', q: 'q' },  class: 'current asc')
        helper.sortable('mooh', 'Mooh')
      end
    end
  end

  describe 'section' do
    it 'should render the template with the correct options' do
      opts = { title: 'title', contents: 'contents', options: { foo: 'options', class: ['row-fluid'] } }
      expect(helper).to receive(:render).with('section', opts).and_return 'rendered'
      result = section('title',  foo: 'options') { 'contents' }
      expect(result).to eq('rendered')
    end
  end
end
