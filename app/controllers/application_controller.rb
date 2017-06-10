require 'ostruct'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  SKUS = ["TRUV-Control-30Day-Preferred", "TRUV-Control-30Day-Retail", "TRUV-Control-30Day-Wholesale", "TRUV-Control-7Day", "TRUV-ReNU", "TRUV-Wholesale-Enrollment"].freeze

  def site_cookies
    cookies.permanent.signed
  end

  def site_params
    OpenStruct.new params
  end

  def products_from_cookies
    products = []
    SKUS.each do |sku|
      products << Product.find_by(sku: sku) if site_cookies[sku.to_sym].present?
    end
    products
  end

  def total
    products = @products.map do |product|
      (site_cookies[product.sku.to_sym] || 1) * product.price
    end
    products.sum
  end
  helper_method :total

  def quantity_select(quantity, n, product)
    "<option data-sku='#{product.sku}' #{selected='selected' if n == quantity} >#{n}</option>".html_safe
  end
  helper_method :quantity_select

  def product_quantity(sku)
    site_cookies[sku.to_sym]
  end
  helper_method :product_quantity
end
