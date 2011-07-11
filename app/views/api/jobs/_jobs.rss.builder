xml.instruct! :xml, :version => "1.0" 

xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Codem - #{title}"
    xml.link root_url

    if @jobs.any?
      xml << (render :partial => "job", :collection => @jobs)
    end
  end
end