class AddColumnsToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :name_field, :text
    add_column :searches, :text_field, :text
    add_column :searches, :type_field, :text
    add_column :searches, :format_field, :text
    add_column :searches, :advanced_field, :text
    add_column :searches, :colors, :text
    add_column :searches, :exact_field, :boolean
  end
end