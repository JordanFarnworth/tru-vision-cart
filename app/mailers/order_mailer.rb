class OrderMailer < ApplicationMailer
  require 'sendgrid-ruby'
  include SendGrid
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

    from = Email.new(email: 'tru-vision@no-reply.com')
    subject = 'Order Confirmation - Tru-Vision'
    to = Email.new(email: 'farnworth.jordan@gmail.com')
    content = Content.new(type: "text/html", value: render_to_string(partial: '/order_mailer/order_mailer').html_safe)
    mail = Mail.new(from, subject, to, content)

    mail(to: 'farnworth.jordan@gmail.com', subject: 'Order Confirmation - Tru-Vision')
  end
end
