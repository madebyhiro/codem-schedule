require 'spec_helper'

feature 'Deleting a preset' do
  let!(:preset) { FactoryGirl.create(:preset, name: 'preset to delete') }

  scenario 'should work' do
    visit presets_path
    click_link 'Delete'
    expect(page).to_not have_text('preset to delete')
  end
end
