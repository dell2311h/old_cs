class AddUuidToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :uuid, :string
  end
end
