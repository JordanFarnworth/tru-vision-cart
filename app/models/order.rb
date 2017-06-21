class Order < ApplicationRecord
  before_create :filter_cc

  validates_presence_of :first_name, :last_name, :company_name, :address, :city, :state, :zip, :phone, :email, :card_number, :expiration, :cvc

  def filter_cc
    cc_num = ".... .... .... #{card_number.split(' ').last}"
    self.card_number = cc_num
  end

end
