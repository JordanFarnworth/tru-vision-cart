require 'addressable/uri'
class CartController < ApplicationController
  protect_from_forgery with: :exception
  SAMPLES = {
      'TRUV-Control-30Day-Preferred' => 1,
      'TRUV-Control-30Day-Wholesale' => 1,
      'TRUV-Control-7Day' => 2
    }
  COMBO_PACK = {
    'TRUV-Control-30Day-Wholesale' => 'TRUV-Wholesale-Enrollment'
  }

  def products
    @errors = []
    if site_params.sku.present?
      check_product_quantity(site_params.sku)
      check_add_rules(site_params.sku)
      add_product(site_params.sku)
    end
    @products = products_from_cookies
  end

  def cart_update
    site_cookies[site_params.sku.to_sym] = site_params.quantity.to_i
    redirect_to cart_path
  end

  def remove_product
    check_remove_rule(site_params.sku)
    cookies.delete site_params.sku.to_sym
    redirect_to cart_path
  end

  def product_quantity_list(sku)
    SAMPLES[sku].present? ? SAMPLES[sku] : 1000
  end
  helper_method :product_quantity_list

  def thankyou

  end

  private

  def check_product_quantity(sku)
    if SAMPLES[sku]
      if ((site_cookies[sku.to_sym] + 1) rescue 1) > SAMPLES[sku]
        @errors << "#{Product.find_by(sku: sku).name} can only be added to the cart #{SAMPLES[sku]} time(s) due to limited supply."
      end
    end
  end

  def check_add_rules(sku)
    add_product COMBO_PACK[sku] if COMBO_PACK[sku]
  end

  def check_remove_rule(sku)
    if COMBO_PACK[sku]
      cookies.delete COMBO_PACK[sku].to_sym
    end
  end

  def add_product(sku)
    if site_cookies[sku.to_sym].present?
      site_cookies[sku.to_sym] += 1 unless @errors.any?
    else
      site_cookies[sku.to_sym] = 1
    end
  end

end
