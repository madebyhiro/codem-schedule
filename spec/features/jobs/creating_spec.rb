require 'spec_helper'

feature "Creating a job" do
  let!(:preset) { FactoryGirl.create(:preset, name: 'Preset') }

  before do
    visit jobs_path
    click_link('New job')
    fill_in_fields
  end

  def fill_in_fields
    fill_in 'Input', with: 'input'
    fill_in 'Output', with: 'output'
    select 'Preset', from: 'Preset'
  end

  scenario "successfully" do
    click_button 'Create Job'

    expect(page).to have_text('input')

    j = Job.last
    expect(j.source_file).to eq('input')
    expect(j.destination_file).to eq('output')
    expect(j.preset).to eq(preset)
  end

  scenario "without an input file" do
    fill_in 'Input', with: ''
    click_button 'Create Job'
    expect(page).to have_text("Source file can't be blank")
  end

  scenario "without an output file" do
    fill_in 'Output', with: ''
    click_button 'Create Job'
    expect(page).to have_text("Destination file can't be blank")
  end

  scenario "without a preset" do
    preset.destroy
    visit new_job_path
    fill_in 'Input', with: 'input'
    fill_in 'Output', with: 'output'
    click_button 'Create Job'
    expect(page).to have_text("Preset can't be blank")
  end
end

