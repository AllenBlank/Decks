class FixParamInSearches < ActiveRecord::Migration
  def change
    rename_column :searches, :params, :parameters
  end
end
