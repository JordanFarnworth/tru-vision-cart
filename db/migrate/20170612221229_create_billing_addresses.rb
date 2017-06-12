class CreateBillingAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :billing_addresses do |t|
      t.references :order, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :company_name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip

      t.timestamps
    end
  end
end
