class RemoveCommanderIdFromDecks < ActiveRecord::Migration
  def change
    remove_column :decks, :commander_id
    add_column :decks, :commander, :string
  end
end
