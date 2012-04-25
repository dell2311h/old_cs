class RenamePerformersEvents < ActiveRecord::Migration
    def change
        rename_table :performers_events, :events_performers
    end 
end
