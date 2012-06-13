class Api::TagsController < Api::BaseController

  skip_before_filter :auth_check, :only => [:index]

  def index
    @video = Video.find_by(current_user, params[:id])
    @tags = @video.tags

    if @tags.count > 0
      render status: :ok, json: @tags.map(&:name)
    else
      render :status => :not_found, json: []
    end
  end

end

