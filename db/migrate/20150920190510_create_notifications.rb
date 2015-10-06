class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :sender_id
      t.references :user
      t.string :type
      t.integer :vote_id

      t.timestamps
    end
    add_index :notifications, :user_id
  end
end
