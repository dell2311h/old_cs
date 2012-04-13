class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.integer :registered_user_id
      t.boolean :is_used, :default => false
      t.string :method
      t.string :invitee
      t.string :code

      t.timestamps
    end
  end
end

