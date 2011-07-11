xml.item do
  xml.title "Job #{job.id} - #{job.state.titleize} at #{I18n.l job.updated_at}"
  xml.description ""
  xml.pubDate job.updated_at.to_s(:rfc822)
  xml.link job_url(job)
  xml.guid job_url(job)
end