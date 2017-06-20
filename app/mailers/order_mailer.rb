class OrderMailer < ApplicationMailer
  default from: 'tru-vision@no-reply.com'

  def order_email(order, billing_address, credit_card_number, products, quantities, total, frd_total)
    @order = order
    @products = products
    @quantities = quantities
    @billing_address = billing_address
    @credit_card_number = credit_card_number
    @total = total
    @frd_total = frd_total

    mail(to: 'test@gmail.com', subject: 'Order Confirmation')
  end
end
