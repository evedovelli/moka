class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :stuff
      t.references :contest
      t.datetime :created_at

      t.timestamps
    end
    add_index :votes, :stuff_id
    add_index :votes, :contest_id
  end
end
