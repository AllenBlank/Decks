class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.text :layout
      t.text :type
      t.text :types
      t.text :colors
      t.text :name
      t.text :rarity
      t.integer :cmc
      t.text :mana_cost
      t.text :text
      t.text :flavor
      t.text :artist
      t.text :rulings
      t.text :legalities
      t.text :number
      t.text :foreign_names
      t.text :source
      t.text :image_name
      t.text :printings
      t.text :release_date
      t.text :subtypes
      t.text :power
      t.text :toughness
      t.text :names
      t.text :supertypes
      t.integer :multiverseid
      t.text :original_type
      t.text :original_text
      t.text :variations
      t.boolean :reserved
      t.integer :loyalty
      t.text :border
      t.text :watermark
      t.boolean :timeshifted
      t.boolean :starter
      t.integer :hand
      t.integer :life

      t.timestamps
    end
  end
end
