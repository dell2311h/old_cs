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
    @video = Video.find params[:video_id]
    params[:songs].map{|k,v| v}.each do |song_params|
      @song = song_params[:id] ? Song.find(song_params[:id]) : Song.create!(song_params)
      @video.songs << @song if !@video.songs.find_by_id(@song)
    end
    @songs = @video.songs
    respond_with @songs, status: :created, location: nil
  end

end

