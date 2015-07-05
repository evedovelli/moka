class AddDurationToBattle < ActiveRecord::Migration
  def change
    add_column :battles, :duration, :integer, default: 60
  end
end
