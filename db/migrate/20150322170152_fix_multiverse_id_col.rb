class FixMultiverseIdCol < ActiveRecord::Migration
  def change
    rename_column :cards, :multiverseid, :multiverse_id
  end
end
