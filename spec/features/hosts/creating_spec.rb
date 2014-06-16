require 'spec_helper'

feature 'Creating a host' do
  before do
    stub_request(:get, 'http://locohost:8080/jobs')
  end

  before do
    visit hosts_path
    click_link 'Add a host'
    fill_in_fields
  end

  def fill_in_fields
    fill_in 'Name', with: 'locohost'
    fill_in 'Url', with: 'http://locohost:8080'
  end

  scenario "successfully" do
    click_button 'Create Host'

    expect(page).to have_text('locohost')
    h = Host.last
    expect(h.name).to eq('locohost')
    expect(h.url).to eq('http://locohost:8080')
  end

  scenario 'without a name' do
    fill_in 'Name', with: ''
    click_button 'Create Host'
    expect(page).to have_text("Name can't be blank")
  end

  scenario 'without an url' do
    fill_in 'Url', with: ''
    click_button 'Create Host'
    expect(page).to have_text("Url can't be blank")
  end
end

