class PresetsController < ApplicationController
  def index
    @presets = Preset.all
  end

  def new
    @preset = Preset.new
  end

  def edit
    @preset = Preset.find(params[:id])
  end
end
