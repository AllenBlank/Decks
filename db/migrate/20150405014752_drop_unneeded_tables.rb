class DropUnneededTables < ActiveRecord::Migration
  def change
    drop_table :sideboards do
    end
    drop_table :cards_sideboards do
    end
    drop_table :cards_decks do
    end
  end
end
