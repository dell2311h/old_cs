object false

if @feed_items
  node(:count) { @feed_items_count }
end

child @feed_items => :feed_items do
  node(:created_at) { |feed_item| feed_item.created_at.to_i }
  node(:template) { |feed_item| feed_item.message_for_feed(@feed_type) }
  node(:actor) { |feed_item| format_for(feed_item.user) }
  node(:entity) { |feed_item| format_for(feed_item.entity) }
  node(:context) { |feed_item| format_for(feed_item.context) }
end

