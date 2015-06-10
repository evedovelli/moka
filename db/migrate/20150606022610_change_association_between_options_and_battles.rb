class ChangeAssociationBetweenOptionsAndBattles < ActiveRecord::Migration
  def up
    drop_table :battles_options
    add_column :options, :battle_id, :integer
    remove_index :votes, :column => :battle_id
    remove_column :votes, :battle_id
  end

  def down
    create_table :battles_options, id: false do |t|
      t.belongs_to :option, index: true
      t.belongs_to :battle, index: true
    end
    remove_column :options, :battle_id
    add_column :votes, :battle_id, :integer
    add_index :votes, :battle_id
  end
end
