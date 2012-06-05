class Api::ReviewFlagsController < Api::BaseController

  def create
    @video = Video.find params[:video_id]
    @video.set_review_flag_by(current_user)

    render status: :ok, json: {}
  end

end

