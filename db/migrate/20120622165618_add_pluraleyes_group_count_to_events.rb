class AddPluraleyesGroupCountToEvents < ActiveRecord::Migration
  def change
    add_column :events, :pluraleyes_group_count, :integer, {:default => 0}

  end
end
