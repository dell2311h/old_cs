class CreateDevicesTable < ActiveRecord::Migration

  def change
    create_table :devices do |t|
      t.string :token, :null => false
      t.integer :user_id
      t.timestamps
    end
  end

end
