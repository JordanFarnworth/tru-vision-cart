class Order < ApplicationRecord
  before_create :filter_cc

  validates_presence_of :first_name, :last_name, :address, :city, :state, :zip, :phone, :email, :expiration, :cvc, :expiration, :country

  if Rails.env == 'development'
    validates :card_number, presence: true
  else
    validates :card_number, presence: true, credit_card_number: true
  end

  validate :valid_date?

  def valid_date?
    if expiration.present?
      exp = expiration.gsub(/\s+/, "")
      unless (exp.match(/\d\d\/\d\d/).try(:length) == 1 || exp.match(/\d\/\d\d/).try(:length) == 1 ||  exp.match(/\d\d\/\d/).try(:length) == 1 ||  exp.match(/\d\/\d/).try(:length) == 1)
        errors.add(:expiration, "Is an invalid date.")
      end
    end
  end

  def filter_cc
    cc_num = ".... .... .... #{card_number.split(' ').last}"
    self.card_number = cc_num
  end

end
