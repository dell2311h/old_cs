class Api::VideosController < Api::BaseController

  skip_before_filter :auth_check, :only => [:show, :likes, :index]
  before_filter :auth_check_for_me, :only => [:index]

  def create
    @videos = current_user.create_videos_by params
    render status: :created, action: :index
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
    @video = Video.find params[:id]
  end

  def update
    @video = current_user.videos.unscoped_find params[:id]
    @video.update_attributes!(params[:video])
    render status: :accepted, action: :show
  end

  def destroy
    @video = current_user.videos.unscoped_find params[:id]
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
    @video = Video.unscoped_find params[:id]
    chunk_binary = params[:chunk][:binary].tempfile.read
    @video.append_chunk_to_file! params[:chunk][:id], chunk_binary
    render status: :ok, action: :show
  end

  def finalize_upload
    @video = Video.unscoped_find params[:id]
    @video.finalize_upload_by_checksum! params[:uploaded_file_checksum]
    render status: :ok, action: :show
  end

  private
    def auth_check_for_me
      auth_check if me?
    end

end

