class AddOptionIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :option_id, :integer
  end
end
