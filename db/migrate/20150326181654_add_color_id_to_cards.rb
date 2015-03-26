class AddColorIdToCards < ActiveRecord::Migration
  def change
    add_column :cards, :color_id, :text
  end
end
