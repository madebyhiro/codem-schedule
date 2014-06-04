require 'spec_helper'

feature "Deleting a host" do
  let!(:host) { FactoryGirl.create(:host, name: 'HostName') }

  before do
    stub_request(:get, 'http://url/jobs')
  end

  scenario 'should work' do
    visit hosts_path
    click_link 'Delete'
    expect(page).to_not have_text('HostName')
  end
end

