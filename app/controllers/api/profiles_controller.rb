class Api::ProfilesController < Api::BaseController

  skip_before_filter :auth_check, :only => [:index]

  def index
    raise I18n.t 'errors.parameters.empty_name' if params[:name].nil?
    @performer = Performer.search({ :performer_name => params[:name] }).first
    @user = User.find_by_username(params[:name])

    render :status => :not_found, json: {} if @user.nil? && @performer.nil?
  end
end