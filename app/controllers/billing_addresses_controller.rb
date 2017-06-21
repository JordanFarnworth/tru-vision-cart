class BillingAddressesController < ApplicationController
  protect_from_forgery with: :exception

  def create
    render json: {}, status: :ok
  end

end
