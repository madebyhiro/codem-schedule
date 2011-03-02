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
    respond_with @preset, :location => presets_path
  end
  
  def edit
    @preset = Preset.find(params[:id])
  end
  
  def update
    @preset = Preset.find(params[:id])
    if @preset.update_attributes(params[:preset])
      flash[:notice] = "Preset has been updated"
    else
      flash[:error] = "Preset could not be updated"
    end
    respond_with @preset, :location => presets_path
  end
  
  def destroy
    preset = Preset.find(params[:id])
    preset.destroy
    flash[:notice] = "Preset has been deleted"
    respond_with preset
  end
end
