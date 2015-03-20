class RemoveCardsFromExpansions < ActiveRecord::Migration
  def change
    remove_column :expansions, :cards
  end
end
