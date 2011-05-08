module JobsHelper
  def progress_as_percentage(progress)
    '%.2f' % (progress.to_f * 100.0)
  end
  
  def new_job_link
    link_to 'New job', new_job_path
  end
  
  def encoding_time(job)
    time = job.completed_at.to_i - job.transcoding_started_at.to_i
    time < 0 ? 0 : time
  end
  
  def destination_filesize(job)
    begin
      File.size(job.destination_file)
    rescue Errno::ENOENT
      'unknown (file gone)'
    end
  end
  
  def notified_at(notification)
    return nil if notification.notified_at.blank?
    
    num = notification.notified_at.to_i - notification.job.completed_at.to_i
    num == 0 ? '00:00:00' : number_to_time(num)
	end
end
