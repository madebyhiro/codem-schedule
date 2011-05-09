class Api::PresetsController < Api::ApiController
  def index
    respond_with Preset.all
  end
  
  def create
    preset = Preset.from_api(params)
    
    if preset.valid?
      respond_with preset, :location => api_preset_url(preset) do |format|
        format.html { redirect_to presets_path }
      end
    else
      respond_with preset do |format|
        format.html { @preset = preset; render "/presets/new"}
      end
    end
  end
  
  def show
    respond_with Preset.find(params[:id])
  end
end
