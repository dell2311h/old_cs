class CreateFeedItems < ActiveRecord::Migration
  def change
    create_table :feed_items do |t|
      t.string :action
      t.integer :user_id
      t.string :itemable_type
      t.integer :itemable_id
      t.integer :contextable_id
      t.string :contextable_type

      t.timestamps
    end
  end
end

