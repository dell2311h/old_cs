class Api::SongsController < Api::BaseController

  def index
    @video = Video.find params[:id]
    @songs = @video.songs
    
    if @songs.count > 0
      @songs = @songs.paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE)
      respond_with @songs, status: :ok, location: nil
    else
      respond_with [], status: :not_found
    end
  end
  
  def create
    @video = Video.find params[:id]
    @song = @video.songs.create! params[:song]
    respond_with @song, status: :created, location: nil
  end
  
end
