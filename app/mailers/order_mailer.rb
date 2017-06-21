class OrderMailer < ApplicationMailer
  default from: 'tru-vision@no-reply.com'

  def order_email(order, billing_address, credit_card_number, products, quantities, total, frd_total, coupon_code)
    @order = order
    @products = products
    @quantities = quantities
    @billing_address = billing_address
    @credit_card_number = credit_card_number
    @total = total
    @frd_total = frd_total
    @coupon_code = coupon_code

    mail(to: 'farnworth.jordan@gmail.com', subject: 'Order Confirmation - Tru-Vision')
  end
end
