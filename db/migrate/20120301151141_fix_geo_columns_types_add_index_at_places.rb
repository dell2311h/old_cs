class FixGeoColumnsTypesAddIndexAtPlaces < ActiveRecord::Migration
  def change
    change_column :places, :latitude, :float, :limit => 25
    change_column :places, :longitude, :float, :limit => 25

    add_index :places, [:latitude, :longitude]
  end
end
