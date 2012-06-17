class Api::VideosController < Api::BaseController

  skip_before_filter :auth_check, :only => [:show, :likes, :index, :most_popular]
  before_filter :auth_check_for_me, :only => [:index]
  before_filter :find_videos, :only => [:index, :show]

  def create
    @videos = current_user.create_videos_by params
    render status: :created, action: :index
  end

  def index
    search_params = params
    search_params[:user_id] = current_user.id if me?
    @videos = @videos.search(search_params).with_calculated_counters.with_events_and_users

    if @videos.count > 0
      @videos = @videos.paginate(:page => params[:page], :per_page => params[:per_page])
    else
      render :status => :not_found, json: {}
    end
  end

  def show
    @videos = @videos.with_calculated_counters
    @videos = @videos.for_user(current_user) if me?
    @video = @videos.find(params[:id])
  end

  def update
    @video = Video.unscoped.for_user(current_user).find params[:id]
    event_id = @video.event_id
    params[:video].delete(:event_id) unless event_id.nil?
    @video.update_attributes!(params[:video])
    @video.create_encoding_media if event_id.nil? && @video.event_id
    render status: :accepted, action: :show
  end

  def destroy
    @video = Video.unscoped.for_user(current_user).find params[:id]
    @video.destroy
    render status: :accepted, json: {}
  end

  def likes
    @video = Video.find(params[:id])
    @users = @video.likers
    render status: :ok, :template => "api/users/index"
  end

  def most_popular
    raise 'count not set!' if params[:count].nil?
    @videos = Video.first_popular params[:count]

    if (@videos.count) < 1
      render :status => :not_found, json: {}

    end
      render status: :ok, :template => "api/videos/index"
  end

  # Chunked uploads

  def append_chunk
    @video = Video.unscoped.for_user(current_user).find params[:id]
    @video.append_chunk_to_file! params[:chunk]
    render status: :ok, action: :show
  end

  def finalize_upload
    @video = Video.unscoped.for_user(current_user).find params[:id]
    @video.finalize_upload_by! params[:file]
    render status: :ok, action: :show
  end

  def view
    @video = Video.unscoped.find params[:id]
    @video.update_attribute(:view_count, @video.view_count.to_i + 1)
    render status: :ok, action: :show
  end

  private
    def auth_check_for_me
      auth_check if me?
    end

    def find_videos
      @videos = Video
      @videos = @videos.unscoped if me?
      @videos = @videos.with_flag_liked_by_me(current_user) if current_user
    end
end
