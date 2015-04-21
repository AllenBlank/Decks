class RemoveUnusedColsFromSearches < ActiveRecord::Migration
  def change
    remove_column :searches, :name
    remove_column :searches, :parameters
  end
end
