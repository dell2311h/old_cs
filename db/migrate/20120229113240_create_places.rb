class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.integer :user_id
      t.integer :latiture
      t.integer :longitude

      t.timestamps
    end
  end
end
