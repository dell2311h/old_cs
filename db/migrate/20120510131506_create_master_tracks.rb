class CreateMasterTracks < ActiveRecord::Migration
  def change
    create_table :master_tracks do |t|
      t.integer :event_id
      t.string :source
      t.integer :version
      t.boolean :is_ready, default: false

      t.timestamps
    end
  end
end

