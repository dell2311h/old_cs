class AddRotationToMetaInfos < ActiveRecord::Migration
  def change
    add_column :meta_infos, :rotation, :integer
  end
end
