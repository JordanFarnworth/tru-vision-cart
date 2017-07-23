class AddCountryToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :country, :string
    add_column :billing_addresses, :country ,:string
  end
end
