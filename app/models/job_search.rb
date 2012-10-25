class JobSearch
  class << self
    def search(jobs, query)
      query.split(' ').each do |part|
        field,value = part.split(':')
        value = value.to_s

        case field
          when /^id|^job/
            jobs = jobs.where("jobs.id = ?", value)
          when /^state/
            jobs = jobs.where("state = ?", value)
          when /^source|^input/
            jobs = jobs.where("source_file LIKE ?", '%'+value+'%')
          when /^dest|^output/
            jobs = jobs.where("destination_file LIKE ?", '%'+value+'%')
          when /^file/
            value = '%'+value+'%'
            jobs = jobs.where("source_file LIKE ? OR destination_file LIKE ?", value, value)
          when /^preset/
            value = '%'+value+'%'
            jobs = jobs.includes(:preset).where("presets.name LIKE ?", value)
          when /^host/
            value = '%'+value+'%'
            jobs = jobs.includes(:host).where("hosts.name LIKE ?", value)
          when /^submitted|^created/
            if dates = val_to_date(value)
              jobs = jobs.where("jobs.created_at BETWEEN ? AND ?", dates[0], dates[1])
            end
          when /^completed/
            if dates = val_to_date(value)
              jobs = jobs.where("jobs.completed_at BETWEEN ? AND ?", dates[0], dates[1])
            end
          when /^started/
            if dates = val_to_date(value)
              jobs = jobs.where("jobs.transcoding_started_at BETWEEN ? AND ?", dates[0], dates[1])
            end
          end
      end

      jobs
    end

    private
      def val_to_date(val)
        val = val.gsub('%', '').gsub('_', ' ')
        if parsed = Chronic.parse(val)
          t0 = parsed.at_beginning_of_day
          t1 = t0 + 1.day
          [t0.to_date, t1.to_date]
        else
          false
        end
      end
  end
end
