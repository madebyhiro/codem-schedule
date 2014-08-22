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

  scenario 'editing segments options' do
    visit presets_path
    click_link 'Edit'
    fill_in 'Segments options', with: '{"SEG": "MENT"}'
    click_button 'Update Preset'
    click_link 'Edit'
    expect(page).to have_selector(%q{input[value='{"SEG": "MENT"}']})
  end
end
