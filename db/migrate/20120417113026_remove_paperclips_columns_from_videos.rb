class RemovePaperclipsColumnsFromVideos < ActiveRecord::Migration
  def up
    remove_column :videos, :thumbnail_file_name
    remove_column :videos, :thumbnail_content_type
    remove_column :videos, :thumbnail_file_size
    remove_column :videos, :thumbnail_updated_at
    remove_column :videos, :clip_file_name
    remove_column :videos, :clip_content_type
    remove_column :videos, :clip_file_size
    remove_column :videos, :clip_updated_at
  end

  def down
    add_column :videos, :thumbnail_file_name, :string
    add_column :videos, :thumbnail_content_type, :string
    add_column :videos, :thumbnail_file_size, :integer
    add_column :videos, :thumbnail_updated_at, :datetime
    add_column :videos, :clip_file_name, :string
    add_column :videos, :clip_content_type, :string
    add_column :videos, :clip_file_size, :integer
    add_column :videos, :clip_updated_at, :datetime
  end
end
