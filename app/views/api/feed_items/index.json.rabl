object false

if @feed_items
  node(:count) { @feed_items.count }
end

child @feed_items => :feed_items do
  node(:created_at) { |feed_item| feed_item.created_at.to_i }
  node(:template) { |feed_item| feed_item.message_for_feed(@feed_type) }
  node(:actor) { |feed_item| { :type => 'User', :id => feed_item.user.id, :text => feed_item.user.username } }
  node(:entity) { |feed_item| { :type => feed_item.entity_type, :id => feed_item.entity_id, :text => feed_item.entity_name } }
  node(:context) { |feed_item| { :type => feed_item.context_type, :id => feed_item.context_id, :text => feed_item.context_name } }
end

