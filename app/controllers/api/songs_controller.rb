class Api::SongsController < Api::BaseController

  def index
    @video = Video.find params[:id]
    @songs = @video.songs
    
    if @songs.count > 0
      @songs = @songs.paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE)
      render status: :ok, json: {songs: @songs, count: @songs.count}
    else
      respond_with [], status: :not_found
    end
  end
  
  def create
    @video = Video.find params[:id]
    @song = Song.find_or_create_by_name(params[:song][:name])
    @video.songs << @song if !@video.songs.find_by_id(@song)
    respond_with @song, status: :created, location: nil
  end
  
end
