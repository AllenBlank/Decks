class AddIndiciesToCards < ActiveRecord::Migration
  def change
    add_index :cards, :name
    add_index :cards, :newest
  end
end
