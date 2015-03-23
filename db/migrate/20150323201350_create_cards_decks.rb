class CreateCardsDecks < ActiveRecord::Migration
  def change
    create_table :cards_decks, id: false do |t|
      t.belongs_to :card, index: true
      t.belongs_to :deck, index: true
    end
  end
end
