class CheckoutController < ApplicationController
  protect_from_forgery with: :exception
  include ActionView::Helpers::NumberHelper
  before_action :prepare_checkout, only: :checkout
  before_action :prepare_order_params, only: :checkout
  before_action :prepre_billing_address_params, only: :checkout

  CARD_ATTRIBUTES = ['card_number', 'expiry', 'cvc']

  def index
    @order = Order.new
    @billing_address = BillingAddress.new
    @products = products_from_cookies
  end

  def sales_tax(zip=nil, *args)
    @zip = zip || params[:zip]
    @country = COUNTRY_MAP[params[:country]]
    client = Taxjar::Client.new(api_key: ENV['TAX_API_KEY'])
    tax_rate = client.rates_for_location(@zip, country: @country).combined_rate rescue false
    tax = (Integer((total * tax_rate) * 100) / Float(100)) if tax_rate
    respond_to do |format|
      format.json do
        if tax_rate
          render json: {new_total: total_with_shipping_and_tax(tax_rate), tax_amount: tax}, status: :ok
        else
          render json: {invalid: 'invalid zip'}, status: :bad_request
        end
      end
    end
  end

  def checkout
    @order = Order.create @new_order_params
    if @new_billing_address_params.any?
      @new_billing_address_params['order_id'] = @order.id
      @custom_billing_address = BillingAddress.create @new_billing_address_params
    end
    if check_for_errors
      render json: {errors: @errors.flatten}, status: :bad_request
    else
      send_order_email
      clear_products_from_cart
      render json: {path: thankyou_path}, status: :ok
    end
  end

  private

  def prepare_order_params
    @coupon_code = params['order']['coupon_code']
    order_params.each do |key, value|
      if CARD_ATTRIBUTES.include? key
        @new_order_params['expiration'] = value if key == 'expiry'
        @new_order_params[key] = value unless key == 'expiry'
      else
        new_key = key.split('order_')[1]
        @new_order_params[new_key] = value
      end
    end
    @card_number = @new_order_params['card_number']
  end

  def prepre_billing_address_params
    unless (billing_params.nil?)
      billing_params.each do |key, value|
        new_key = key.split('billing_address_')[1]
        @new_billing_address_params[new_key] = value
      end
    end
  end

  def check_for_errors
    if @order.errors.any?
      @errors << @order.errors.full_messages.map {|e| "Order #{e}"}
    end
    if @custom_billing_address && @custom_billing_address.errors.any?
      @errors << @custom_billing_address.errors.full_messages.map {|e| "Billing Address #{e}"}
    end
    if billing_params.has_key? :billing_address_country
      country = COUNTRY_MAP[billing_params[:billing_address_country]]
      zip = billing_params[:billing_address_zip]
      @errors << 'Invalid billing address zip code' unless ValidatesZipcode.valid?(zip, country)
    end
    if order_params.has_key? :order_country
      country = COUNTRY_MAP[order_params[:order_country]]
      zip = order_params[:order_zip]
      @errors << 'Invalid billing details zip code' unless ValidatesZipcode.valid?(zip, country)
    end
    @errors.any?
  end

  def prepare_checkout
    @new_order_params = {}
    @new_billing_address_params = {}
    @custom_billing_address = nil
    @errors = []
    @products ||= products_from_cookies
    @quantities = @products.map do |p|
      {p.sku => product_quantity(p.sku)}
    end.reduce({}, :merge)
    @total = number_to_currency(total)
    tax_rate = calc_tax_rate(params)
    @frd_total = number_to_currency(total_with_shipping_and_tax(tax_rate))
    @shipping = calculate_shipping
  end


  def send_order_email
    OrderMailer.order_email(
      @order,
      @custom_billing_address,
      @card_number,
      @products,
      @quantities,
      @total,
      @frd_total,
      @coupon_code,
      @shipping
    ).deliver_later
  end

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
    :order_country,
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
    :billing_address_country,
    :billing_address_company_name,
    :billing_address_first_name,
    :billing_address_last_name,
    :billing_address_state,
    :billing_address_zip
    )
  end

end
