module Api::FeedItemsHelper

  def format_for(object)
    type = object.class.to_s if object
    id = object.id if object
    text = name_for(object) if object
    { :type => type, :id => id, :text => name_for(object) }
  end

  def name_for(object)
    current_user == object ? "You" : FeedItem.name_for(object)
  end

end

