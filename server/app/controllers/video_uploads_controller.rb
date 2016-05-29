class VideoUploadsController < ApplicationController
  before_action :set_video_upload, only: [:show, :update, :destroy]

  # GET /video_uploads
  def index
    @video_uploads = VideoUpload.all

    render json: @video_uploads
  end

  # GET /video_uploads/1
  def show
    render json: @video_upload
  end

  # TODO: endpoint should be authenticated. add user relation to VideoUpload
  #
  # POST /video_uploads
  def create
    @video_upload = VideoUpload.new
    @video_upload.save!
    @video_upload.prepare!

    render json: @video_upload, status: :created, location: @video_upload
  end

  # PATCH/PUT /video_uploads/1
  def update
    if @video_upload.update(video_upload_params)
      render json: @video_upload
    else
      render json: @video_upload.errors, status: :unprocessable_entity
    end
  end

  # DELETE /video_uploads/1
  def destroy
    @video_upload.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video_upload
      @video_upload = VideoUpload.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def video_upload_params
      params.fetch(:video_upload, {})
    end
end
