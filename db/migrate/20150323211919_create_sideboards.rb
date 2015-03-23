class CreateSideboards < ActiveRecord::Migration
  def change
    create_table :sideboards do |t|
      t.timestamps null: false
      t.belongs_to :deck, index: true
    end
    
    create_table :cards_sideboards, id: false do |t|
      t.belongs_to :card, index: true
      t.belongs_to :sideboard, index: true
    end
  end
end
