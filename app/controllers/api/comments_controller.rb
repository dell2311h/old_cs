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

  private
    def find_commentable
      class_name = case params[:commentable]
        when /videos|places|events/
          params[:commentable][0..-2]
      end
      model_class = class_name.capitalize.constantize
      @commentable = model_class.find(params[:id])
    end

end

