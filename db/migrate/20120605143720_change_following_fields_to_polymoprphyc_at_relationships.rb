class ChangeFollowingFieldsToPolymoprphycAtRelationships < ActiveRecord::Migration

  def up
    add_column :relationships, :followable_id, :integer
    add_column :relationships, :followable_type, :string
    remove_column :relationships, :followed_id
  end

  def down
    add_column :relationships, :followed_id, :integer
    remove_column :relationships, :followable_id
    remove_column :relationships, :followable_type
  end

end

