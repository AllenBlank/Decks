class FixTypeColums < ActiveRecord::Migration
  def change
    rename_column :cards, :type, :card_type
    rename_column :expansions, :type, :expansion_type
  end
end
