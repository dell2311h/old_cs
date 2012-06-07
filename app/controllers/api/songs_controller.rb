class Api::SongsController < Api::BaseController

  skip_before_filter :auth_check, :only => [:index]

  def index

    @songs = Song.search params

    if (@songs_count = @songs.count(:distinct => true)) > 0
      @songs = @songs.paginate(:page => params[:page], :per_page => params[:per_page]).with_calculated_counters(params)
    else
      render :status => :not_found, json: {}
    end

  end

  def create
    @video = Video.unscoped.find params[:video_id]
    @songs = @video.add_songs_by_user(current_user, params[:songs])
    raise "You can't add songs for this video" unless @songs
    render :status => :ok, :action => "added_songs"
  end

end

