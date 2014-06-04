require 'spec_helper'

feature "Editing a host" do
  let!(:host) { FactoryGirl.create(:host) }

  before do
    stub_request(:get, 'http://url/jobs')
    visit hosts_path
    click_link 'Edit'
  end

  scenario "name" do
    fill_in 'Name', with: 'New name'
    click_button 'Update Host'
    expect(page).to have_text('New name')
  end

  scenario "url" do
    fill_in 'Url', with: 'New url'
    click_button 'Update Host'
    expect(page).to have_text('New url')
  end

  scenario "no name" do
    fill_in 'Name', with: ''
    click_button 'Update Host'
    expect(page).to have_text("Name can't be blank")
  end
end

