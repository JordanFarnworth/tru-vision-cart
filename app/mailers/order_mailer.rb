class OrderMailer < ApplicationMailer
  # require 'sendgrid-ruby'
  # include SendGrid
  default from: 'tru-vision@no-reply.com'

  def order_email(order, billing_address, credit_card_number, products, quantities, total, frd_total, coupon_code, shipping)
    @order = order
    @products = products
    @quantities = quantities
    @billing_address = billing_address
    @credit_card_number = credit_card_number
    @total = total
    @frd_total = frd_total
    @coupon_code = coupon_code
    @shipping = shipping

    mail(to: ['farnworth.jordan@gmail.com', 'beachbumgg1@gmail.com'], subject: 'Order Confirmation')

    # goign to leave this here incase I ever figure out how to get sendgrid to work with my template
    # but for now /shrug it works
    # from = Email.new(email: 'tru-vision@no-reply.com')
    # subject = 'Order Confirmation - Tru-Vision'
    # to = Email.new(email: 'farnworth.jordan@gmail.com')
    # content = Content.new(type: 'text/plain', value: 'Hello, Email!')
    # mail = Mail.new(from, subject, to, content)
    # sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    # response = sg.client.mail._('send').post(request_body: mail.to_json)
  end
end
