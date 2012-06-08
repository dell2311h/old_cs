class Api::PerformersController < Api::BaseController

  skip_before_filter :auth_check, :only => [:index, :remote, :show]

  def remote
    @performers = EventfulPerformer.search params
    if @performers.empty?
      respond_with [], :status => :not_found
      return
    end
  end

  def index
    @performers = Performer.search params
    if @performers.count > 0
      @performers = @performers.paginate(:page => params[:page], :per_page => params[:per_page]).with_flag_followed_by(current_user).with_calculated_counters
    else
      render :status => :not_found, json: {}
    end
  end

  def show
    @performer = Performer.with_flag_followed_by(current_user).with_calculated_counters.find params[:id]
  end

  def create
    @performer = Performer.create! params[:performer]
    render :status => :ok, :action => :show
  end

end

