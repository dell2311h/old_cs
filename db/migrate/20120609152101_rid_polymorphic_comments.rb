class RidPolymorphicComments < ActiveRecord::Migration
  def up
    remove_column :comments, :commentable_id
    remove_column :comments, :commentable_type
    add_column :comments, :video_id, :integer
  end

  def down
    add_column :comments, :commentable_id, :integer
    add_column :comments, :commentable_type, :string
    remove_column :comments, :video_id
  end
end
