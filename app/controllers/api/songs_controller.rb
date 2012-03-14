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
    params[:songs].each do |song_params|
      @song = song_params[:id] ? Song.find(song_params[:id]) : Song.create!(song_params)
      @video.songs << @song if !@video.songs.find_by_id(@song)     
    end
    @songs = @video.songs
    respond_with @songs, status: :created, location: nil
  end
  
end
