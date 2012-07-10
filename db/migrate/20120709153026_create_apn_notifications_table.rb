class CreateApnNotificationsTable < ActiveRecord::Migration

  def change
    create_table :apn_notifications do |t|
      t.integer :user_id, :null => false
      t.string :sound
      t.string :alert, :size => 150
      t.integer :badge
      t.text :custom_properties
      t.datetime :sent_at
      t.timestamps
    end
    add_index :apn_notifications, :user_id
  end

end
