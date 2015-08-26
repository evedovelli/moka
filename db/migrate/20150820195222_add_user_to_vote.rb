class AddUserToVote < ActiveRecord::Migration
  def change
    add_column :votes, :user_id, :integer
    add_index :votes, [:option_id, :user_id], unique: true
    add_index :votes, :user_id
  end
end
