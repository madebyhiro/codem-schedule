class PresetsController < ApplicationController
  def index
    @presets = Preset.all
  end
  
  def new
  end
end
