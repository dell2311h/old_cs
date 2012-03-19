class CreatePlaceProviders < ActiveRecord::Migration
 def change
    create_table :place_providers do |t|
      t.integer :place_id
      t.integer :remote_id
      t.string :provider

      t.timestamps
    end
  end
end
