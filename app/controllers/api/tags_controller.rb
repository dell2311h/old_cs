class Api::TagsController < Api::BaseController
  
  before_filter :find_taggable
  
  def index
    @tags = @taggable.tags
        
    if @tags.count > 0
      @tags = @tags.paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE)
      render status: :ok, json: {:tags => @tags, count: @tags.count}
    else
      respond_with [], :status => :not_found
    end 
  end
  
  def create
    tag_name = params[:tag][:name].downcase
    @tag = Tag.find_or_create_by_name(tag_name)
    @taggable.tags << @tag if !@taggable.tags.find_by_id(@tag)
    respond_with @tag, :status => :created, :location => nil
  end
  
  private
    def find_taggable
      class_name = case params[:taggable]
        when /videos|places|events/
          params[:taggable][0..-2]
      end
      model_class = class_name.capitalize.constantize
      @taggable = model_class.find(params[:id])
    end
  

end
