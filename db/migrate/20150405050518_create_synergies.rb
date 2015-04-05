class CreateSynergies < ActiveRecord::Migration
  def change
    create_table :synergies do |t|
      t.integer :pile_id
      t.integer :compliment_id
      t.float :power
      t.string :type

      t.timestamps null: false
    end
  end
end
