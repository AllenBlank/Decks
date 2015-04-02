class RemoveCommanderIdFromDecks < ActiveRecord::Migration
  def change
    remove_column :decks, :commander
    add_column :decks, :commander, :string
  end
end
