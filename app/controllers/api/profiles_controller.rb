class Api::ProfilesController < Api::BaseController

  def index
    raise I18n.t 'errors.parameters.empty_name' if params[:name].nil?
    @performer = Performer.search({ :performer_name => params[:name] })
    @user = User.search_by({ :name => params[:name] }, current_user)
    
    @performer = @performer.first
    @user = @user.first

    render :status => :not_found, json: {} if @user.nil? && @performer.nil?
  end
end