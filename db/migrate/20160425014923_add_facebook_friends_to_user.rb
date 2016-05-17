class AddFacebookFriendsToUser < ActiveRecord::Migration
  def change
    create_table :facebook_friendships do |t|
      t.integer :user_id
      t.integer :facebook_friend_id

      t.timestamps
    end
  end
end
