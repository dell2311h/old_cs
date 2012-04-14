class ChangeMehthodColumnNameToMode < ActiveRecord::Migration
  def up
    rename_column :invitations, :method, :mode
  end

  def down
    rename_column :invitations, :mode, :method
  end
end

