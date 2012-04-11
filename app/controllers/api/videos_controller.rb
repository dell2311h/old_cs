class Api::VideosController < Api::BaseController

  skip_before_filter :auth_check, :only => [:show, :likes]
  skip_before_filter :auth_check, :only => [:index], :unless => Proc.new { |c| me? }

  def create
    @event = Event.find params[:event_id]
    @video = current_user.videos.build params[:video]
    @video.event = @event
    @video.save!
    render status: :created, action: :show
  end

  def index

    @videos = me? ? (Video.all_for_user current_user) : (Video.find_videos params)

    if @videos.count > 0
      @videos = @videos.paginate(:page => params[:page], :per_page => params[:per_page])
    else
      render :status => :not_found, json: {}
    end
  end

  def show
    @video = Video.find(params[:id])
  end

  def update
    @video = current_user.videos.find params[:id]
    @video.update_attributes!(params[:video])
    render status: :accepted, action: :show
  end

  def destroy
    @video = current_user.videos.find params[:id]
    @video.destroy
    render status: :accepted, json: {}
  end

  def likes
    @video = Video.find(params[:id])
    @users = @video.likers
    render status: :ok, :template => "api/users/index"
  end

  # Chunked uploads

  def append_chunk
    @video = Video.find params[:id]
    @video.append_chunk_to_file! params[:chunk][:id], params[:chunk][:binary]
    render status: :ok, action: :show
  end

  def finalize_upload
    @video = Video.find params[:id]
    @video.finalize_upload_by_checksum! params[:uploaded_file_checksum]
    render status: :ok, action: :show
  end

end

