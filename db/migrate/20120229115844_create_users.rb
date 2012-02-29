class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :login
      t.string :password
      t.string :phone
      t.integer :age
      t.string :avatar

      t.timestamps
    end
  end
end
