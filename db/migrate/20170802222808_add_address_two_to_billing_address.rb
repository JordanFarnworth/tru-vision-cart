class AddAddressTwoToBillingAddress < ActiveRecord::Migration[5.0]
  def change
    add_column :billing_addresses, :address_two, :string
  end
end
