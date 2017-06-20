class CheckoutController < ApplicationController
  protect_from_forgery with: :exception
  include ActionView::Helpers::NumberHelper

  def index
    @order = Order.new
    @billing_address = BillingAddress.new
    @products = products_from_cookies
  end

  def checkout
    new_order_params = {}
    new_billing_address_params = {}
    errors = []
    order_params.each do |key, value|
      if ['card_number', 'expiry', 'cvc'].include? key
        new_order_params['expiration'] = value if key == 'expiry'
        new_order_params[key] = value unless key == 'expiry'
      else
        new_key = key.split('order_')[1]
        new_order_params[new_key] = value
      end
    end
    order = Order.create new_order_params
    if order.errors.any?
      errors << order.errors.full_messages
    end
    if (billing_params rescue false)
      billing_params.each do |key, value|
        new_key = key.split('billing_address_')[1]
        new_billing_address_params[new_key] = value
      end
      ba = BillingAddress.create new_billing_address_params
      ba.order_id = order.id
      ba.save
      if ba.errors.any?
        errors << ba.errors.full_messages
      end
    end

    if errors.any?
      render json: {errors: errors.flatten}, status: :bad_request
    else
      quantities = products_from_cookies.map do |p|
        {p.sku => product_quantity(p.sku)}
      end.reduce({}, :merge)
      frd_total = number_to_currency(total + 11.99)
      OrderMailer.order_email(order, ba ? ba : nil, new_order_params['card_number'], products_from_cookies, quantities, number_to_currency(total), frd_total).deliver_later
      render json: {path: thankyou_path}, status: :ok
    end
  end

  private

  def order_params
    params.require(:order).permit(
    :order_address,
    :order_city,
    :order_company_name,
    :order_email,
    :order_first_name,
    :order_last_name,
    :order_phone,
    :order_state,
    :order_zip,
    :card_number,
    :cvc,
    :expiry
    )
  end

  def billing_params
    params.require(:billing_address).permit(
    :billing_address_address,
    :billing_address_city,
    :billing_address_company_name,
    :billing_address_first_name,
    :billing_address_last_name,
    :billing_address_state,
    :billing_address_zip
    )
  end

end
