class AddUploadedToCards < ActiveRecord::Migration
  def change
    add_column :cards, :uploaded, :boolean
  end
end
