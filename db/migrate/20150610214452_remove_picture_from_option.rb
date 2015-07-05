class RemovePictureFromOption < ActiveRecord::Migration
  def up
    remove_column :options, :picture
  end

  def down
    add_column :options, :picture, :integer
  end
end
