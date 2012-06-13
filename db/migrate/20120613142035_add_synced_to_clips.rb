class AddSyncedToClips < ActiveRecord::Migration
  def change
    add_column :clips, :synced, :boolean, {:default => 0}

  end
end
