class CreateExpansions < ActiveRecord::Migration
  def change
    create_table :expansions do |t|
      t.text :name
      t.text :code
      t.text :magic_rarities_codes
      t.text :release_date
      t.text :border
      t.text :type
      t.text :cards
      t.text :old_code
      t.text :gatherer_code
      t.text :block
      t.text :booster
      t.boolean :online_only

      t.timestamps
    end
  end
end
