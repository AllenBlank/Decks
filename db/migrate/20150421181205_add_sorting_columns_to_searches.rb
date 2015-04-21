class AddSortingColumnsToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :sort_by_field, :string
    add_column :searches, :sort_direction_field, :string
  end
end
