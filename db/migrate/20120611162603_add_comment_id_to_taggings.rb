class AddCommentIdToTaggings < ActiveRecord::Migration
  def change
    add_column :taggings, :comment_id, :integer
  end
end
