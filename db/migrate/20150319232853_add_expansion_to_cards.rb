class AddExpansionToCards < ActiveRecord::Migration
  def change
    add_reference :cards, :expansion, index: true
    add_foreign_key :cards, :expansions
  end
end
