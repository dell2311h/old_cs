class Api::DevicesController < Api::BaseController

  def create
    @device = Device.register_device current_user, params[:device_token]
    render status: :ok, action: :show
  end

  def destroy
    Device.unregister_device current_user
    render status: :ok, json: {}
  end

end