class BillingAddress < ApplicationRecord
  belongs_to :order

    validates_presence_of :first_name, :last_name, :company_name, :address, :city, :state, :zip
end
