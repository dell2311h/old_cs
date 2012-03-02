class FixColumnNameAtPlaces < ActiveRecord::Migration
  def change
    rename_column :places, :latiture, :latitude
  end
end
