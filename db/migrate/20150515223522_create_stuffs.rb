class CreateStuffs < ActiveRecord::Migration
  def change
    create_table :stuffs do |t|
      t.integer :picture
      t.string :name

      t.timestamps
    end
  end
end
