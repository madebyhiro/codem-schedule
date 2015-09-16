require 'spec_helper'

feature 'Editing a preset' do
  let!(:preset) { FactoryGirl.create(:preset) }

  scenario 'editing name' do
    visit presets_path
    click_link 'Edit'
    fill_in 'Name', with: 'New name'
    click_button 'Update Preset'
    expect(page).to have_text('New name')
  end

  scenario 'editing parameters' do
    visit presets_path
    click_link 'Edit'
    fill_in 'Parameters', with: 'new params'
    click_button 'Update Preset'
    expect(page).to have_text('new params')
  end

  scenario 'editing segment time' do
    visit presets_path
    click_link 'Edit'
    fill_in 'HLS Segment time', with: '20'
    click_button 'Update Preset'
    expect(page).to have_text('20')
  end
end
