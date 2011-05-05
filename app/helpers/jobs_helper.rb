module JobsHelper
  def progress_as_percentage(progress)
    '%.2f' % (progress.to_f * 100.0)
  end
  
  def new_job_link
    link_to 'New job', new_job_path
  end
end
