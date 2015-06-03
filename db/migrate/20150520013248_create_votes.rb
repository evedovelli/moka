class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :option
      t.references :battle
      t.datetime :created_at

      t.timestamps
    end
    add_index :votes, :option_id
    add_index :votes, :battle_id
  end
end
