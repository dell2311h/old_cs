class AddDobWebsiteBioToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dob, :date       # date of birth
    add_column :users, :website, :string
    add_column :users, :bio, :text
  end
end

