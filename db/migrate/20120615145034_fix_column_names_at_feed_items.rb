class FixColumnNamesAtFeedItems < ActiveRecord::Migration
def change
    change_table :feed_items do |t|
      t.rename :itemable_id, :entity_id
      t.rename :itemable_type, :entity_type
      t.rename :contextable_id, :context_id
      t.rename :contextable_type, :context_type
    end
  end

end

