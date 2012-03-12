class Api::CommentsController < Api::BaseController

  before_filter :prepare_commentable_object

  def index
    @comments = Comment
        
    if @comments.count > 0
      @comments = @comments.paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE)
      render status: :ok, json: {:comments => @comments.as_json(:include => :user), count: @comments.count}
    else
      respond_with [], :status => :not_found
    end

  end
  
  def create
    @comment = @commentable_object.comments.build params[:comment]
    @comment.user = @current_user
    @comment.save!
    respond_with @comment, :status => :created, :location => nil
  end

  private
    def prepare_commentable_object
      model_class = params[:commentable].capitalize.constantize
      @commentable_object = model_class.find(params[:id])
    end
    
end
