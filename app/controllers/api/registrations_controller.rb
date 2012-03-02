class Api::RegistrationsController < ApplicationController
   skip_before_filter :verify_authenticity_token

  def create
    @user = User.new(params[:user])
    if @user.save
      if @user.active_for_authentication?
        sign_in('user', @user)
        render :json => {status: 'ok', message: 'ok'}
      else
        expire_session_data_after_sign_in!
        render :json => {status: 'error', message: 'Some error'}
      end
    else
      @user.clean_up_passwords
      render :text => {status: 'error', errors: @user.errors.full_messages }
    end
  end

end
