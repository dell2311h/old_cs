class AddEncoderIdToMasterTracks < ActiveRecord::Migration
  def change
    add_column :master_tracks, :encoder_id, :string
  end
end

