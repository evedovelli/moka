class AddDescriptionToBattles < ActiveRecord::Migration
  def change
    add_column :battles, :description, :string
  end
end
