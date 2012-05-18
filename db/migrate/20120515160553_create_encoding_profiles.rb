class CreateEncodingProfiles < ActiveRecord::Migration
  def change
    create_table :encoding_profiles do |t|
      t.string :profile_id
      t.string :name

      t.timestamps
    end
  end
end
