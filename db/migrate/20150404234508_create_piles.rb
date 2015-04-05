class CreatePiles < ActiveRecord::Migration
  def change
    create_table :piles do |t|
      t.integer :card_id, index: true
      t.integer :deck_id, index: true
      t.integer :count
      t.string :board
      t.text :tags

      t.timestamps null: false
    end
  end
end