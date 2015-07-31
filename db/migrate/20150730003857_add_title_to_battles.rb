class AddTitleToBattles < ActiveRecord::Migration
  def change
    add_column :battles, :title, :string
  end
end
