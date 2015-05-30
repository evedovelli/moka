class AssociatesContestsAndStuffs < ActiveRecord::Migration
  def change
    create_table :contests_stuffs, id: false do |t|
      t.belongs_to :stuff, index: true
      t.belongs_to :contest, index: true
    end
  end
end
