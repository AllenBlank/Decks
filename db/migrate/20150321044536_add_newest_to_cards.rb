class AddNewestToCards < ActiveRecord::Migration
  def change
    add_column :cards, :newest, :boolean, default: true
  end
end
