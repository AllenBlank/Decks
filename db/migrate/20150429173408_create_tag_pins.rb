class CreateTagPins < ActiveRecord::Migration
  def change
    create_table :tag_pins do |t|
      t.integer :tag_id

      t.integer :pile_id
      t.integer :deck_id
      t.integer :synergy_id

      t.timestamps null: true
    end
    
    add_index :tag_pins, :tag_id
    add_index :tag_pins, :pile_id
    add_index :tag_pins, :deck_id
    add_index :tag_pins, :synergy_id
  end
end
