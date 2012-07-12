class Api::ProfilesController < Api::BaseController

  skip_before_filter :auth_check, :only => [:index]

  def index
    raise I18n.t 'errors.parameters.empty_name' if params[:name].nil?
    # Need refactored. Look at story ID 32659217
    @performer = current_user ? Performer.search({ :performer_name => params[:name] }).with_flag_followed_by(current_user).first : Performer.search({ :performer_name => params[:name] }).first
    @user = current_user ? User.with_flag_followed_by(current_user).find_by_username(params[:name]) : User.find_by_username(params[:name])

    render :status => :not_found, json: {} if @user.nil? && @performer.nil?
  end
end