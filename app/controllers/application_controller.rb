require 'ostruct'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def site_cookies
    cookies.permanent.signed
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


  def quantity_select(quantity, n, product)
    "<option data-sku='#{product.sku}' #{selected='selected' if n == quantity} >#{n}</option>".html_safe
  end
  helper_method :quantity_select

  def product_quantity(sku)
    site_cookies[sku.to_sym]
  end
  helper_method :product_quantity

  private

  def sku_codes
    @skus ||= Product.all.pluck :sku
  end
end
