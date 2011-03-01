class PresetsController < ApplicationController
  respond_to :html, :json, :xml
  
  def index
    @presets = Preset.all
    respond_with @presets
  end

  def new
    @preset = Preset.new
  end
  
  def create
    @preset = Preset.new(params[:preset])
    if @preset.save
      flash[:notice] = "Preset has been created"
    else
      flash[:error] = "Preset could not be saved"
    end
    respond_with @preset
  end
end
