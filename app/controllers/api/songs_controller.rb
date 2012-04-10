class Api::SongsController < Api::BaseController

  skip_before_filter :auth_check, :only => [:index]

  def index
  
    @songs = Song
   
    if params[:video_id]
      @video = Video.find params[:video_id]
      @songs = @video.songs
    end
    
    if params[:event_id]
      @event = Event.find params[:event_id]
      @songs = @event.songs
    end
    
    if params[:song_name]
      @songs = Song.suggestions_by_name(params[:song_name])
    end  
    
    if params[:q]
      @songs = Song.with_name_like(params[:q])
    end
    
    if @songs.count > 0
      @songs = @songs.paginate(:page => params[:page], :per_page => params[:per_page])
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
