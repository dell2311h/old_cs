class AddPluraleyesIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :pluraleyes_id, :string
  end
end

