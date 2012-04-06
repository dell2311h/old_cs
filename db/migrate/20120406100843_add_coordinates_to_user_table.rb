class AddCoordinatesToUserTable < ActiveRecord::Migration
  def change
     add_column :users, :latitude,  :float, :limit => 25
     add_column :users, :longitude, :float, :limit => 25
  end
end
