class Api::PerformersController < Api::BaseController

  skip_before_filter :auth_check, :only => [:index, :remote]

  def remote
    @performers = EventfulPerformer.search params
    if @performers.empty?
      respond_with [], :status => :not_found
      return
    end
  end

  def index
    @performers = Performer.search params
    if @performers.empty?
      respond_with [], :status => :not_found
      return
    end
  end

end