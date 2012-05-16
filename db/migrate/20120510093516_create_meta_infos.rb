class CreateMetaInfos < ActiveRecord::Migration
  def change
    create_table :meta_infos do |t|
      t.integer :video_id
      t.datetime :recorded_at
      t.float :latitude, :limit => 25
      t.float :longitude, :limit => 25
      t.integer :duration

      t.timestamps
    end
  end
end

