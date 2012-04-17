class Remote::FacebookUser
  include RemoteUser
  def friends
    result = api.get_connections(self.uid, "friends")

    parse result
  end

  def post(message, link, target_uid)
    api.put_wall_post(message, {:link => link} , target_uid)
  end

  private

    def parse result
      result.map do |element|
        { uid: element["id"], name: element["name"], avatar_url: "http://graph.facebook.com/#{element["id"]}/picture" }
      end
    end

    def api
      Koala::Facebook::API.new self.token if @api.nil?
    end

end

