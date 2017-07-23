require 'ostruct'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  SAMPLES = {
      'TRUV-Control-30Day-Preferred' => 1,
      'TRUV-Control-30Day-Wholesale' => 1,
      'TRUV-Control-7Day' => 2
    }.freeze

  COUNTRIES_ALLOWED = [:US, :AU, :CA].freeze

  COUNTRY_MAP = {
    "Australia" => 'AU',
    "United States" => 'US',
    "Canada" => 'CA'
  }.freeze

  def site_cookies
    cookies.permanent.signed
  end

  def sample_pack_skus
    SAMPLES
  end

  def calc_tax_rate(params)
    client = Taxjar::Client.new(api_key: ENV['TAX_API_KEY'])
    if params[:billing_address].has_key? :billing_address_zip
      country = COUNTRY_MAP[params[:billing_address][:billing_address_country]]
      zip = params[:billing_address][:billing_address_zip]
    else
      country = COUNTRY_MAP[params[:order][:order_country]]
      zip = params[:order][:order_zip]
    end
    client.rates_for_location(zip, country: country).combined_rate
  end

  def not_sample_pack_skus
    regular_sample_skus = sample_pack_skus.map { |k,v| k }
    Product.where.not(sku: regular_sample_skus).pluck :sku
  end

  def site_params
    OpenStruct.new params
  end

  def products_from_cookies
    sku_codes.map do |sku|
      site_cookies[sku.to_sym].present? ? Product.find_by(sku: sku) : nil
    end.compact
  end

  def clear_products_from_cart
    products_from_cookies.each do |product|
      cookies.delete product.sku.to_sym
    end
  end

  def total
    products = products_from_cookies.map do |product|
      (site_cookies[product.sku.to_sym] || 1) * product.price
    end
    products.sum
  end
  helper_method :total

  def total_with_shipping
    total + calculate_shipping(:int)
  end

  def total_with_shipping_and_tax(tax_rate)
    float = (tax_rate * total)
    total_with_shipping + (Integer(float * 100) / Float(100))
  end

  def calculate_shipping(*args)
    cart_product_skus = products_from_cookies.pluck :sku
    result = cart_product_skus.map {|sku| not_sample_pack_skus.include? sku}
    if args.include? :int
      result.include?(true) ? 11.99 : 0.0
    else
      result.include?(true) ? '11.99' : 'Free'
    end
  end
  helper_method :calculate_shipping

  def quantity_select(quantity, n, product)
    "<option data-sku='#{product.sku}' #{selected='selected' if n == quantity} >#{n}</option>".html_safe
  end
  helper_method :quantity_select

  def product_quantity(sku)
    site_cookies[sku.to_sym]
  end
  helper_method :product_quantity

  def countries
    CS.countries.select {|k,v| COUNTRIES_ALLOWED.include? k}.map {|k, v| v}.reverse
  end
  helper_method :countries

  private

  def sku_codes
    @skus ||= Product.all.pluck :sku
  end
end
