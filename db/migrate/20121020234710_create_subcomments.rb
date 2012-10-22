class CreateSubcomments < ActiveRecord::Migration
  def change
    create_table :subcomments do |t|
      t.string :content
      t.integer :comment_id

      t.timestamps
    end
  end
end
