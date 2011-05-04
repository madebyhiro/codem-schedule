class PresetsController < ApplicationController
  def index
    @presets = Preset.all
  end
  
  def new
    @preset = Preset.new
  end
  
  def create
    @preset = Preset.new(params[:preset])
    if @preset.save
      redirect_to presets_path, :notice => "Preset has been created"
    else
      render :action => "new"
    end
  end
end
