class RemoveRegisteredUserIdAndIsUsedFromInvitations < ActiveRecord::Migration
  def up
    remove_column :invitations, :is_used
    remove_column :invitations, :registered_user_id
  end

  def down
    add_column :invitations, :registered_user_id, :integer
    add_column :invitations, :is_used, :boolean
  end
end

