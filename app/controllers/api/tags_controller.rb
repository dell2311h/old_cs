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
    @tags = Tag.add_for(@taggable, params[:tags])
    respond_with @tags, :status => :created, :location => nil
  end

  private
    def find_taggable
      @taggable = Tag.find_taggable_by(current_user, params)
    end

end

