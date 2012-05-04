class AddTimingsToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :start_time, :integer
    add_column :videos, :end_time,   :integer
  end
end
