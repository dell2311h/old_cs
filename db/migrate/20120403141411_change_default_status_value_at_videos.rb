class ChangeDefaultStatusValueAtVideos < ActiveRecord::Migration
  def up
    change_column_default :videos, :status, -1 # STATUS_UPLOADING
  end

  def down
    change_column_default :videos, :status, 0 # STATUS_NEW
  end
end
