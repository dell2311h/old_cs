class AddViewCountToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :view_count, :integer, {:default => 0}

  end
end
