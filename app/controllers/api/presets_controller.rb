class Api::PresetsController < Api::ApiController
  def index
    respond_with Preset.all
  end
  
  def create
    preset = Preset.from_api(params)
    preset.save
    respond_with preset, :location => api_preset_url(preset)
  end
  
  def show
    respond_with Preset.find(params[:id])
  end
end
