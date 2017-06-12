class CheckoutController < ApplicationController
  protect_from_forgery with: :exception

  def index
    @order = Order.new
    @billing_address = BillingAddress.new
    @products = products_from_cookies
  end

end
