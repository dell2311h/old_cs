class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.integer :uid
      t.string :token

      t.timestamps
    end
  end
end
