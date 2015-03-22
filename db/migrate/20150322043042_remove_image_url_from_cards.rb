class RemoveImageUrlFromCards < ActiveRecord::Migration
  def change
    remove_column :cards, :image_url
  end
end
