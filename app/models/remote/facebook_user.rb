require 'koala'
class Remote::FacebookUser
  include RemoteUser
  def friends
    @result = api.get_connections(self.uid, "friends")

    parse
  end

  private
    def parse
      @result.map do |element|
        { uid: element["id"], name: element["name"], avatar_url: "http://graph.facebook.com/#{element["id"]}/picture" }
      end
    end
    @result
    @api
    def api
      @api = Koala::Facebook::API.new self.token if @api.nil?

      @api
    end
end