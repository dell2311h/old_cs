class Api::SongsController < Api::BaseController

  def index
   
    if params[:video_id]
      @video = Video.find params[:video_id]
      @songs = @video.songs
    end
    
    if params[:event_id]
      @event = Event.find params[:event_id]
      @songs = @event.songs
    end
    
    if params[:song_name]
      @songs = Song.with_name_like(params[:song_name])
    end  
    
    render :status => :not_found if @songs.count == 0
  end
  
  def create
    @video = Video.find params[:video_id]
    params[:songs].each do |song_params|
      @song = song_params[:id] ? Song.find(song_params[:id]) : Song.create!(song_params)
      @video.songs << @song if !@video.songs.find_by_id(@song)     
    end
    @songs = @video.songs
    respond_with @songs, status: :created, location: nil
  end
  
end
