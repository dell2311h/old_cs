class CreateClipsTable < ActiveRecord::Migration
 def change
    create_table :clips do |t|
      t.integer :video_id
      t.string :source
      t.string :encoding_id
      t.string :source
      t.string :type

      t.timestamps
    end
  end
end
