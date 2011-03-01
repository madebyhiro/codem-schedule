class PresetsController < ApplicationController
  def index
    @presets = Preset.all
  end

  def new
    @preset = Preset.new
    @preset.notifications = [Notification.new(:kind => 'email'), 
                             Notification.new(:kind => 'network'), 
                             Notification.new(:kind => 'filesystem')]
  end
  
  def create
    @preset = Preset.new(params[:preset])
    if @preset.save
      flash[:notice] = "Preset has been created"
      redirect_to presets_path
    else
      flash[:error] = "Preset could not be saved"
      render :action => "new"
    end
  end
end
