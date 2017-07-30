class AddImageUrlToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :image_url, :string
  end
end
