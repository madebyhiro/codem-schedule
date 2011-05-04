Then /^a job should have been created with the following attributes:$/ do |table|
  attributes = table.rows_hash
  if preset_name = attributes.delete("preset_name")
    attributes["preset_id"] =  Preset.find_by_name(preset_name).id
  end
  Job.last.attributes.should include_hash(attributes)
end
