class AddPluraleyesIdToClips < ActiveRecord::Migration
  def change
    add_column :clips, :pluraleyes_id, :string
  end
end

