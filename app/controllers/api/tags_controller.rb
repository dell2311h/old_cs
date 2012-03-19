class Api::TagsController < Api::BaseController
  
  before_filter :find_taggable
  
  skip_before_filter :auth_check, :only => [:index]
  
  def index
    @tags = @taggable.tags
        
    if @tags.count > 0
      render status: :ok, json: @tags.map(&:name)
    else
      render :status => :not_found, json: []
    end 
  end
  
  def create
    params[:tags].each do |tag_name|
      @tag = Tag.find_or_create_by_name(tag_name.downcase)
      @taggable.tags << @tag if !@taggable.tags.find_by_id(@tag)
    end
    @tags = @taggable.tags.map(&:name)
    respond_with @tags, :status => :created, :location => nil
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
