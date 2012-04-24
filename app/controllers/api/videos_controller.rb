class Api::VideosController < Api::BaseController

  skip_before_filter :auth_check, :only => [:show, :likes, :index]
  before_filter :auth_check_for_me, :only => [:index]

  def create
    @videos = current_user.create_videos_by params
    render status: :created, action: :index
  end

  def index

    search_params = params
    search_params[:user_id] = current_user if me?
    @videos = me? ? (Video.all_for_user current_user) : (Video.search search_params)
    videos_id = @videos.map &:id
    @likes_count = Video.likes_count_by videos_id
    @comments_count = Video.comments_count_by videos_id

    if @videos.count > 0
      @videos = @videos.paginate(:page => params[:page], :per_page => params[:per_page])
    else
      render :status => :not_found, json: {}
    end
  end

  def show
    @video = me? ? current_user.videos.unscoped_find(params[:id]) : Video.find(params[:id])
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
    @video.append_chunk_to_file! params[:chunk]
    render status: :ok, action: :show
  end

  def finalize_upload
    @video = Video.unscoped_find params[:id]
    @video.finalize_upload_by! params[:file]
    render status: :ok, action: :show
  end

  private
    def auth_check_for_me
      auth_check if me?
    end

end

