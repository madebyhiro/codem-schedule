# = The Codem scheduler API
#
# == Resources
# The following resources can be viewed and manipulated through this API.
#
# === Hosts
# Creating and viewing of hosts.
# A host is a representation of a Codem \Transcoder instance.
# 
# ==== Endpoints
# GET  /api/hosts::     See Api::HostsController#index
# POST /api/hosts::     See Api::HostsController#create
# GET  /api/hosts/:id:: See Api::HostsController#show
# PUT /api/hosts/:id::   See Api::HostsController#update
# DELETE /api/hosts/:id:: See Api::HostsController#destroy
#
# === Jobs
# Creating and viewing of jobs.
#
# ==== Endpoints
# GET /api/jobs::             See Api::JobsController#index
# GET /api/jobs/scheduled::   See Api::JobsController#scheduled
# GET /api/jobs/accepted::    See Api::JobsController#accepted
# GET /api/jobs/processing::  See Api::JobsController#processing
# GET /api/jobs/on_hold::     See Api::JobsController#on_hold
# GET /api/jobs/success::     See Api::JobsController#success
# GET /api/jobs/failed::      See Api::JobsController#failed
# POST /api/jobs::            See Api::JobsController#create
# GET /api/jobs/:id::         See Api::JobsController#show
# DELETE /api/jobs/purge::       See Api::JobsController#purge
#
# === Presets
# Creating and viewing of presets.
#
# ==== Endpoints
# GET /api/presets::    See Api::PresetsController#index
# POST /api/presets::   See Api::PresetsController#create
# GET /api/presets/:id:: See Api::PresetsController#show
# PUT /api/presets/:id:: See Api::PresetsController#update
# DELETE /api/presets/:id:: See Api::PresetsController#destroy
#
# === State Changes
# Viewing of state changes of a job.
#
# ==== Endpoints
# GET /api/jobs/:id/state_changes:: See Api::StateChangesController#index
#
# === Notifications
# Notifications are sent to an email address or url if a job is either completed or has failed
#
# ==== Endpoints
# GET /api/jobs/:id/notifications:: See Api::NotificationsController#index
#
# === Scheduling
#
# ==== Endpoints
# GET /api/scheduler::    See Api::SchedulerController#schedule
#
# === Statistics
# GET /api/statistics::   See Api::StatisticsController#show
module Api
  # = Base API controller
  # This controller provides JSON and XML responders.
  class ApiController < ApplicationController
    respond_to :json, :xml
  end
end