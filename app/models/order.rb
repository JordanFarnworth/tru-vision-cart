class Order < ApplicationRecord
  before_create :filter_cc

  def filter_cc
    cc_num = ".... .... .... #{card_number.split(' ').last}"
    self.card_number = cc_num
  end
end
