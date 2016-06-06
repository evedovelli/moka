class AddFacebookFriendSignUpToEmailSettings < ActiveRecord::Migration
  def change
    add_column :email_settings, :facebook_friend_sign_up, :boolean, default: true
  end
end
