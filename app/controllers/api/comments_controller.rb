class Api::CommentsController < Api::BaseController

  before_filter :prepare_commentable_object

  def index
    @comments = @commentable_object.comments
        
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
      class_name = case params[:commentable]
        when /videos|places|events/
          params[:commentable][0..-2]
      end
      model_class = class_name.capitalize.constantize
      @commentable_object = model_class.find(params[:id])
    end
    
end
