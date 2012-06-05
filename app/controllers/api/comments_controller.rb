class Api::CommentsController < Api::BaseController

  before_filter :find_commentable, :only => [:index, :create]

  skip_before_filter :auth_check, :only => [:index, :event_videos_comments_list]

  def index
    @comments = @commentable.comments.order("created_at DESC")

    @comments = @comments.paginate(:page => params[:page], :per_page => params[:per_page])

    render :status => :not_found, json: {} if @comments.count == 0
  end

  def event_videos_comments_list
    @event = Event.find params[:event_id]
    @comments = @event.videos_comments.paginate(:page => params[:page], :per_page => params[:per_page])

    if @comments.count > 0
      render status: :ok, action: :index
    else
      render status: :not_found, json: {}
    end
  end

  def create
    @comment = @commentable.comments.build params[:comment]
    @comment.user = current_user
    @comment.save!
    render status: :ok, action: :show
  end

  def destroy
    @comment = Comment.find(params[:comment_id])
    raise "You can't delete this comment" unless @comment.destroy_by(current_user)
    render status: :accepted, json: {}
  end


  private
    def find_commentable
      @commentable = Comment.find_commentable_by(current_user, params)
    end

end

