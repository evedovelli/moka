class AddUnreadNotificationsToUser < ActiveRecord::Migration
  def change
    add_column :users, :unread_notifications, :integer, default: 0
  end
end
