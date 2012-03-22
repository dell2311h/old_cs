class FixUidColumnTypeAtAuthentications < ActiveRecord::Migration
  def up
    change_column :authentications, :uid, 'integer unsigned'
  end
  
  def down
    change_column :authentications, :uid, :integer
  end
end
