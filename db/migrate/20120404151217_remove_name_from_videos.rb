class RemoveNameFromVideos < ActiveRecord::Migration
  def up
    remove_column :videos, :name
  end

  def down
    add_column :videos, :name, :string
  end
end
