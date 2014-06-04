require 'spec_helper'

feature "Deleting a job" do
  let!(:job) { FactoryGirl.create(:job, state: Job::Success) }

  scenario "should work" do
    visit jobs_path
    click_link job.id
    click_link 'Delete job'
    expect(page).to_not have_text(job.id)
  end
end

