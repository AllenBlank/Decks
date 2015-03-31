class AddFormatsToCards < ActiveRecord::Migration
  def change
    add_column :cards, :formats, :text
  end
end
