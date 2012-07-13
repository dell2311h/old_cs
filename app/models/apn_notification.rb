class ApnNotification < ActiveRecord::Base

  validates :sound, :alert, :badge, :presence => true
  validates :user_id, :numericality => { :only_integer => true }

  belongs_to :user
  has_one :device, :through => :user

  scope :undelivered, where(:sent_at => nil)

  def self.store(message, user)
    apn_params = self.format_apn_notification user, message
    ApnNotification.create({:badge  => apn_params[:badge],
                            :alert  => apn_params[:alert],
                            :sound  => apn_params[:sound],
                            :user_id => user.id})
  end

  def self.deliver_undelivered
    notifications = self.find_undelivered
    unless notifications.empty?
      apns_notifications = self.create_apns_notifications notifications
      deliver apns_notifications
      self.update_sent notifications
    end
  end

  def format_apns_notification
    APNS::Notification.new(self.user.device.token, :alert => self.alert, :badge => self.badge, :sound => Settings.notifications.apn.sound)
  end

  private

  def self.update_sent(notifications)
    ApnNotification.update_all({:sent_at => Time.now}, {:id => notifications.map{|notification| notification.id }} )
  end

  def self.deliver(apns_notifications)
    apns_sender = configure_apns
    apns_sender.send_notifications(apns_notifications)
  end

  def self.configure_apns
    APNS.pem = "#{Rails.root}/#{Settings.notifications.apn.pem_sertificate}"
    APNS.host = Settings.notifications.apn.gateway

    APNS
  end

  def self.create_apns_notifications(notifications)
    apns_notifications = []
    notifications.each do |notification|
      apns_notifications << notification.format_apns_notification if notification.user && notification.user.device
    end
   apns_notifications
  end

  def self.find_undelivered
    ApnNotification.undelivered.includes(:device, :user)
  end

  def self.format_apn_notification(user, message)
    badge = user.new_notifications_count
    alert = message
    sound = Settings.notifications.apn.sound

    {:badge => badge, :alert => alert, :sound => sound}
  end

end