class FixUidColumnTypeAtAuthentications < ActiveRecord::Migration
  def change
    change_column :authentications, :uid, :integer, :limit => 8
  end
end
