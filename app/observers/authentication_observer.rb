class AuthenticationObserver < ActiveRecord::Observer

  def after_create(authenication)
    FeedItem.create_for_join_crowdsync_via_social_network(authenication)
  end

end

