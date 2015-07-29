class AddHiddenToBattles < ActiveRecord::Migration
  def change
    add_column :battles, :hidden, :boolean, default: false
  end
end
