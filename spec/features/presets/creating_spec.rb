require 'spec_helper'

feature 'Creating a preset' do
  before do
    visit presets_path
    click_link 'New preset'
    fill_in_fields
  end

  def fill_in_fields
    fill_in 'Name', with: 'name'
    fill_in 'Parameters', with: 'foo'
    fill_in 'Thumbnail options', with: '{"foo":"bar"}'
  end

  scenario 'should work' do
    click_button 'Create Preset'
    expect(page).to have_text('name')
    p = Preset.last
    p.name.should == 'name'
    p.parameters.should == 'foo'
    p.thumbnail_options.should == '{"foo":"bar"}'
  end

  scenario 'no name' do
    fill_in 'Name', with: ''
    click_button 'Create Preset'
    expect(page).to have_text("Name can't be blank")
  end

  scenario "neither params nor thumbnail options" do
    fill_in 'Parameters', with: ''
    fill_in 'Thumbnail options', with: ''
    click_button 'Create Preset'
    expect(page).to have_text("Either parameters or thumbnail options should be specified")
  end

  scenario "invalid thumbnail options" do
    fill_in 'Thumbnail options', with: 'foo:bar'
    click_button 'Create Preset'
    expect(page).to have_text("Thumbnail options must be valid JSON")
  end
end
