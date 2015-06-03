class CreateBattles < ActiveRecord::Migration
  def change
    create_table :battles do |t|
      t.datetime :starts_at
      t.datetime :finishes_at

      t.timestamps
    end
  end
end
