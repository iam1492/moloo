class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.integer :price, :limit => 8
      t.integer :handed, :default => 0
      t.integer :user_id

      t.timestamps
    end
  end
end
