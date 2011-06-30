require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationHelper do
  it "should set the title correctly" do
    should_receive(:content_for).with(:title)
    title('foo')
  end
  
  describe "sortable" do
    before(:each) do
      stub!(:sort_column).and_return nil
      stub!(:sort_direction).and_return nil
      stub!(:link_to)
    end

    describe "without a sorting" do
      it "should return the correct link" do
        should_receive(:link_to).with('The ID', {:sort => 'id', :direction => 'asc'}, {:class => nil})
        sortable('id', 'The ID')
      end
    end
    
    describe "with a sorting" do
      before(:each) do
        stub!(:sort_column).and_return 'mooh'
        stub!(:sort_direction).and_return 'asc'
      end
      
      it "should return the correct link" do
        should_receive(:link_to).with('Mooh', {:sort => 'mooh', :direction => 'desc'}, {:class => 'current asc'})
        sortable('mooh', 'Mooh')
      end
    end
  end
end
