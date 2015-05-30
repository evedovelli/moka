class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.datetime :starts_at
      t.datetime :finishes_at

      t.timestamps
    end
  end
end
