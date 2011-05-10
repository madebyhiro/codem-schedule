# = Presets Controller
#
# A preset represents command line options for ffmpeg sent to the Transcoder
class Api::PresetsController < Api::ApiController
  # == Returns a list of presets
  #
  # == Example:
  #   $ curl http://localhost:3000/api/presets
  #
  #   [
  #     {"preset":{
  #       "created_at":"2011-05-09T11:59:53Z",
  #       "id":1,
  #       "name":"h264",
  #       "parameters":"-acodec libfaac -ab 96k -ar 44100 -vcodec libx264 -vb 416k -vpre slow -vpre baseline -s 320x180 -y",
  #       "updated_at":"2011-05-09T11:59:53Z"}
  #     }
  #   ]
  def index
    respond_with Preset.all
  end

  # == Creates a preset
  #
  # Creates a preset using the specified parameters, which are all required. If the request was valid,
  # the created preset is returned. If the request could not be completed, a list of errors will be returned.
  #
  # === Parameters
  # All parameters are required
  # name:: Name of the preset
  # params:: Parameters to use
  #
  # === Response codes
  # success:: <tt>201 created</tt>
  # failed::  <tt>406 Unprocessable Entity</tt>
  #
  # === Example
  #   $ curl -d 'name=webm&parameters=params' http://localhost:3000/api/presets
  #
  #   {"preset":{
  #     "created_at":"2011-05-10T14:44:07Z",
  #     "id":3,
  #     "name":"webm",
  #     "parameters":
  #     "params",
  #     "updated_at":"2011-05-10T14:44:07Z"}
  #   }
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

  # == Displays a preset
  #
  # === Parameters
  # id:: Id of the preset to display
  #
  # === Example
  #   $ curl curl http://localhost:3000/api/presets/1
  #
  #   {"preset":{
  #     "created_at":"2011-05-10T14:44:07Z",
  #     "id":3,
  #     "name":"webm",
  #     "parameters":
  #     "params",
  #     "updated_at":"2011-05-10T14:44:07Z"}
  #   }
  def show
    respond_with Preset.find(params[:id])
  end
end
