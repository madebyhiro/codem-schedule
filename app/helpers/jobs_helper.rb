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
	
	def compression_rate(job)
	  pct = (destination_filesize(job).to_f / job.filesize.to_f) * 100.0
	  '%.2f' % pct
	end
	
  def number_to_time(seconds)
    return nil if seconds.to_i < 1
    time = Time.gm(2000,1,1) + seconds.to_i
    Time.at(time).utc.strftime("%H:%M:%S")
  end
end
