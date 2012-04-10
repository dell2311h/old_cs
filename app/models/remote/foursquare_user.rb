class Remote::FoursquareUser
  include RemoteUser

  def friends
    response = api.user_friends self.uid

    parse response
  end

  private
    @api

    def api
      @api = Foursquare2::Client.new({ oauth_token: self.token }) if @api.nil?
      
      @api
    end

    def parse response
      response['items'].map do |element|
        { uid: element["id"], name: (element["firstName"] +' ' + element['lastName']), avatar_url: element['photo'] }
      end
    end

    
end