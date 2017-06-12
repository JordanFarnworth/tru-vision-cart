class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :first_name
      t.string :last_name
      t.string :company_name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :email
      t.string :card_number
      t.string :expiration
      t.string :cvc

      t.timestamps
    end
  end
end
