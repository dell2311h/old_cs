require 'koala'
class Remote::FacebookUser
  include RemoteUser
  def friends
    results = api.get_connections(@uid, "friends")

    results
  end

  private
    @api
    def api
      @api = Koala::Facebook::API.new @token if @api.nil?

      @api
    end
end