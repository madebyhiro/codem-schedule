require 'spec_helper'

feature 'Searching for jobs' do
  let!(:job) { FactoryGirl.create(:job, source_file: 'find_me') }
  let!(:not_found) { FactoryGirl.create(:job, source_file: 'not_to_be_found') }

  def search(key, value)
    visit jobs_path

    visit jobs_path(q: "#{key}:#{value}")

    expect(page).to have_text('find_me')
    expect(page).to_not have_text('not_to_be_found')
  end

  scenario 'by id' do
    search 'id', job.id
  end

  scenario 'by state' do
    not_found.update_attributes state: Job::Failed
    search 'state', 'scheduled'
  end

  scenario 'by input' do
    not_found.update_attributes source_file: 'bar'
    search 'input', job.source_file
  end

  scenario 'by source' do
    not_found.update_attributes source_file: 'bar'
    search 'source', job.source_file
  end

  scenario 'by dest' do
    not_found.update_attributes destination_file: 'bar'
    search 'dest', job.destination_file
  end

  scenario 'by output' do
    not_found.update_attributes destination_file: 'bar'
    search 'output', job.destination_file
  end

  scenario 'by file' do
    not_found.update_attributes destination_file: 'bar'
    search 'file', job.destination_file
  end

  scenario 'by preset' do
    not_found.preset = FactoryGirl.create(:preset, name: 'bar')
    not_found.save

    job.preset = FactoryGirl.create(:preset, name: 'found')
    job.save

    search 'preset', 'found'
  end

  scenario 'by host' do
    not_found.host = FactoryGirl.create(:host, name: 'bar')
    not_found.save

    job.host = FactoryGirl.create(:host, name: 'found')
    job.save

    search 'host', 'found'
  end

  scenario 'by submitted' do
    not_found.update_attributes created_at: 3.days.ago
    search 'submitted', 'today'
  end

  scenario 'by created' do
    not_found.update_attributes created_at: 3.days.ago
    search 'created', 'today'
  end

  scenario 'by completed' do
    job.update_attributes completed_at: Time.now
    search 'completed', 'today'
  end

  scenario 'by started' do
    job.update_attributes transcoding_started_at: Time.now
    search 'started', 'today'
  end

  scenario 'incorrect date' do
    visit jobs_path(q: 'started:moo')
    expect(page).to have_text(job.id)
    expect(page).to have_text(not_found.id)
  end
end
