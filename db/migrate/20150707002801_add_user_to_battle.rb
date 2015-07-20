class AddUserToBattle < ActiveRecord::Migration
  def change
    add_column :battles, :user_id, :integer
    add_index :battles, :user_id
  end
end
