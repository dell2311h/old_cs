class AddImageToEvents < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      add_column :events, :image_file_name, :string
      add_column :events, :image_content_type, :string
      add_column :events, :image_file_size, :integer
      add_column :events, :image_updated_at, :datetime
    end
  end

  def self.down
    remove_column :events, :image_file_name
    remove_column :events, :image_content_type
    remove_column :events, :image_file_size
    remove_column :events, :image_updated_at
  end
end
