class CreateCategories < ActiveRecord::Migration

  def up
    create_table :categories do |t|
      t.string :name
      t.integer :position
      t.timestamps
    end

    add_column :events, :category_id, :integer
    add_index :events, :category_id
  end

  def down
    drop_table :categories
    remove_column :events, :category_id
    remove_index :events, :category_id
  end
end

