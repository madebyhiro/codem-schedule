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
# GET /api/jobs/processing::  See Api::JobsController#processing
# GET /api/jobs/on_hold::     See Api::JobsController#on_hold
# GET /api/jobs/success::     See Api::JobsController#success
# GET /api/jobs/failed::      See Api::JobsController#failed
# POST /api/jobs::            See Api::JobsController#create
# GET /api/jobs/:id::         See Api::JobsController#show
# POST /api/jobs/:id/retry::  See Api::JobsController#retry
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
#
# === Probing
# GET /api/probe::        See Api::ApiController#probe
module Api
  # = Base API controller
  # This controller provides JSON and XML responders.
  class ApiController < ApplicationController
    respond_to :json, :xml

    # == Probes a file using ffprobe
    #
    # Using ffprobe, a transcoder can give detailed information about a specific file. This endpoint
    # makes a synchronous request to an available transcoder and returns the result.
    #
    # === Parameters
    # <tt>source_file</tt>:: The file to probe
    #
    # === Example
    #   $ curl 'http://localhost:3000/api/probe?source_file=/tmp/movie.mov'
    #
    #   {
    #     "ffprobe": {
    #         "streams": [
    #             {
    #                 "index": 0,
    #                 "codec_name": "mpeg4",
    #                 "codec_long_name": "MPEG-4 part 2",
    #                 "profile": "Simple Profile",
    #                 "codec_type": "video",
    #                 "codec_time_base": "1/25",
    #                 "codec_tag_string": "mp4v",
    #                 "codec_tag": "0x7634706d",
    #                 "width": 640,
    #                 "height": 480,
    #                 "has_b_frames": 1,
    #                 "sample_aspect_ratio": "1:1",
    #                 "display_aspect_ratio": "4:3",
    #                 "pix_fmt": "yuv420p",
    #                 "level": 1,
    #                 "quarter_sample": "0",
    #                 "divx_packed": "0",
    #                 "r_frame_rate": "10/1",
    #                 "avg_frame_rate": "10/1",
    #                 "time_base": "1/3000",
    #                 "start_pts": 0,
    #                 "start_time": "0.000000",
    #                 "duration_ts": 256500,
    #                 "duration": "85.500000",
    #                 "bit_rate": "261816",
    #                 "nb_frames": "855",
    #                 "disposition": {
    #                     "default": 1,
    #                     "dub": 0,
    #                     "original": 0,
    #                     "comment": 0,
    #                     "lyrics": 0,
    #                     "karaoke": 0,
    #                     "forced": 0,
    #                     "hearing_impaired": 0,
    #                     "visual_impaired": 0,
    #                     "clean_effects": 0,
    #                     "attached_pic": 0
    #                 },
    #                 "tags": {
    #                     "creation_time": "2005-10-17 22:54:33",
    #                     "language": "eng",
    #                     "handler_name": "Apple Video Media Handler"
    #                 }
    #             },
    #             {
    #                 "index": 1,
    #                 "codec_name": "aac",
    #                 "codec_long_name": "AAC (Advanced Audio Coding)",
    #                 "codec_type": "audio",
    #                 "codec_time_base": "1/32000",
    #                 "codec_tag_string": "mp4a",
    #                 "codec_tag": "0x6134706d",
    #                 "sample_fmt": "fltp",
    #                 "sample_rate": "32000",
    #                 "channels": 1,
    #                 "channel_layout": "mono",
    #                 "bits_per_sample": 0,
    #                 "r_frame_rate": "0/0",
    #                 "avg_frame_rate": "0/0",
    #                 "time_base": "1/32000",
    #                 "start_pts": 0,
    #                 "start_time": "0.000000",
    #                 "duration_ts": 2737152,
    #                 "duration": "85.536000",
    #                 "bit_rate": "43476",
    #                 "nb_frames": "2673",
    #                 "disposition": {
    #                     "default": 1,
    #                     "dub": 0,
    #                     "original": 0,
    #                     "comment": 0,
    #                     "lyrics": 0,
    #                     "karaoke": 0,
    #                     "forced": 0,
    #                     "hearing_impaired": 0,
    #                     "visual_impaired": 0,
    #                     "clean_effects": 0,
    #                     "attached_pic": 0
    #                 },
    #                 "tags": {
    #                     "creation_time": "2005-10-17 22:54:34",
    #                     "language": "eng",
    #                     "handler_name": "Apple Sound Media Handler"
    #                 }
    #             }
    #         ],
    #         "format": {
    #             "filename": "/tmp/movie.mov",
    #             "nb_streams": 2,
    #             "nb_programs": 0,
    #             "format_name": "mov,mp4,m4a,3gp,3g2,mj2",
    #             "format_long_name": "QuickTime / MOV",
    #             "start_time": "0.000000",
    #             "duration": "85.500000",
    #             "size": "3284257",
    #             "bit_rate": "307298",
    #             "probe_score": 100,
    #             "tags": {
    #                 "major_brand": "qt  ",
    #                 "minor_version": "537199360",
    #                 "compatible_brands": "qt  ",
    #                 "creation_time": "2005-10-17 22:54:32"
    #             }
    #         }
    #     }
    # }
    def probe
      response = Transcoder.probe(params[:source_file])
      render json: response
    end
  end
end
