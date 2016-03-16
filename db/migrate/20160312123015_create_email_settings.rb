class CreateEmailSettings < ActiveRecord::Migration
  def change
    create_table :email_settings do |t|
      t.integer :user_id
      t.boolean :new_follower, default: true

      t.timestamps
    end
  end
end
