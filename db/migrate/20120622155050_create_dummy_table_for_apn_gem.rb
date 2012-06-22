class CreateDummyTableForApnGem < ActiveRecord::Migration
  def change
    create_table :apn_bases do |t|
    end
  end
end
