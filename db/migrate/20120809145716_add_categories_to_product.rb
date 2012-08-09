class AddCategoriesToProduct < ActiveRecord::Migration
  def change
  	add_column :products, :categories, :string
  end
end
