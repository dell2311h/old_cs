class RidPolymorphicTagging < ActiveRecord::Migration
  def up
    remove_column :taggings, :taggable_type
    rename_column :taggings, :taggable_id, :video_id
  end

  def down
    add_column :taggings, :taggable_type, :string
    rename_column :taggings, :video_id, :taggable_id
  end
end
