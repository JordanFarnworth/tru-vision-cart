class AddAddressTwoToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :address_two, :string
  end
end
