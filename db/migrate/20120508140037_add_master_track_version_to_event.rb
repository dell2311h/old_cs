class AddMasterTrackVersionToEvent < ActiveRecord::Migration
  def change
    add_column :events, :master_track_version, :integer
  end
end
