class CreateTimings < ActiveRecord::Migration
  def up
    create_table :timings do |t|
      t.integer :video_id
      t.integer :start_time
      t.integer :end_time
      t.integer :version

      t.timestamps
    end

    remove_column :videos, :end_time
    remove_column :videos, :start_time
  end

  def down
    add_column :videos, :end_time,   :integer
    add_column :videos, :start_time, :integer

    drop_table :timings
  end
end
