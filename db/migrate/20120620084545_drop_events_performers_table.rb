class DropEventsPerformersTable < ActiveRecord::Migration
  def up
    drop_table :events_performers
  end

  def down
  end
end

