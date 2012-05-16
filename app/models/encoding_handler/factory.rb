class EncodingHandler::Factory

  def self.handle_profile profile_id
    handle_class = get_handler_by profile_id

    handle_class.new
  end

  private
    def self.get_handler_by profile_id

     profile = EncodingProfile.find_by_profile_id! profile_id

     "EncodingHandler::#{profile.name.camelize}".constantize
  end
end