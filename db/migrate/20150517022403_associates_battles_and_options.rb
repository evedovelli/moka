class AssociatesBattlesAndOptions < ActiveRecord::Migration
  def change
    create_table :battles_options, id: false do |t|
      t.belongs_to :option, index: true
      t.belongs_to :battle, index: true
    end
  end
end
