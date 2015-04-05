class AddIndexesToSynergies < ActiveRecord::Migration
  def change
    add_index :synergies, :pile_id
    add_index :synergies, :compliment_id
    add_index :synergies, [:pile_id, :compliment_id], unique: true
  end
end
