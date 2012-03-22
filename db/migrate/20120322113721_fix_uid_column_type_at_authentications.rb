class FixUidColumnTypeAtAuthentications < ActiveRecord::Migration
  def up
    change_column :authentications, :uid, 'bigint unsigned'
  end
  
  def down
    change_column :authentications, :uid, :integer
  end
end
