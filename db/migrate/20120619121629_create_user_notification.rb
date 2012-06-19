class CreateUserNotification < ActiveRecord::Migration
  def change
    create_table :user_notifications do |t|
      t.integer :user_id
      t.integer :feed_item_id
      t.date    :creation_date
    end
  end
end
