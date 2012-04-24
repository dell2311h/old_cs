class CreatePerfomersEventsTable < ActiveRecord::Migration
  def change
    create_table "performers_events", :id => false do |t|
      t.column "performer_id", :integer, :null => false
      t.column "event_id",     :integer, :null => false
    end
  end
end
