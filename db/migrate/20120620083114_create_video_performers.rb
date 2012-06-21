class CreateVideoPerformers < ActiveRecord::Migration
  def change
    create_table :video_performers do |t|
      t.integer :video_id
      t.integer :performer_id

      t.timestamps
    end
  end
end

