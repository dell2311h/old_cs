class RenameClipsTypeFieldToClipType < ActiveRecord::Migration
  def up
    rename_column :clips, :type, :clip_type
  end

  def down
    rename_column :clips, :clip_type, :type
  end
end
