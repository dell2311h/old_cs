class AddEventfullIdToEnventTable < ActiveRecord::Migration
  def self.up
    add_column :events, :eventful_id, :string
  end
  def self.down
    remove_column :events, :eventful_id
  end
end
