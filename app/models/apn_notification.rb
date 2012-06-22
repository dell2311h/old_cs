class ApnNotification < UserNotification

  def send_to_device(device)
    apn_params = format_apn_notification
    APN::Notification.create({:badge  => apn_params[:badge],
                              :alert  => apn_params[:alert],
                              :sound  => apn_params[:sound],
                              :device_id => device.id})
  end

  def self.deliver(feed_item)
    device = self.find_device_by_token feed_item.user.device_token
    if device
      notification = create_by_feed_item(feed_item)
      notification.send_to_device device
    end
  end

  private

  def format_apn_notification
    badge = 1
    alert = format_message
    sound = "apnsTune.caf"

    {:badge => badge, :alert => alert, :sound => sound}
  end

  def self.find_device_by_token device_token
   APN::Device.find_or_create_by_token device_token
  end

end