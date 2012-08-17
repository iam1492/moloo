class RemoveCategoriesFromProduct < ActiveRecord::Migration
  def up
    remove_column :products, :categories
  end

  def down
    add_column :products, :categories, :string
  end
end
