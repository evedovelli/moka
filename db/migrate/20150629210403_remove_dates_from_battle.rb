class RemoveDatesFromBattle < ActiveRecord::Migration
  def up
    remove_column :battles, :finishes_at
  end

  def down
    add_column :battles, :finishes_at, :datetime
  end
end
