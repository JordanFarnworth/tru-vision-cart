class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :sku, null: false
      t.string :name, null: false
      t.float :price, null: false
      t.text :description

      t.timestamps
    end
    add_index :products, :sku, unique: true
  end
end
