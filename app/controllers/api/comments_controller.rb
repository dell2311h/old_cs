class Api::CommentsController < Api::BaseController

  before_filter :find_video, :only => [:index, :create]

  skip_before_filter :auth_check, :only => [:index, :event_videos_comments_list]

  def index
    @comments = @video.comments.order("created_at DESC")
    if @comments.count > 0
      @comments = @comments.paginate(:page => params[:page], :per_page => params[:per_page])
    else
      render :status => :not_found, :json => {}
    end
  end

  def event_videos_comments_list
    @event = Event.find params[:event_id]
    @comments = @event.videos_comments

    if @comments.count > 0
      @comments.paginate(:page => params[:page], :per_page => params[:per_page])
      render status: :ok, action: :index
    else
      render status: :not_found, json: {}
    end
  end

  def create
    @comment = @video.comments.build params[:comment]
    @comment.user = current_user
    @comment.save!
    render status: :ok, action: :show
  end

  def destroy
    @comment = Comment.find(params[:comment_id])
    raise I18n.t('errors.models.comment.you_can_not_delete') unless @comment.destroy_by(current_user)
    render status: :accepted, json: {}
  end


  private
    def find_video
      @video = Video.find_by(current_user, params[:id])
    end

end

