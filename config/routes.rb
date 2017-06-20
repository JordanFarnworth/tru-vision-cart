Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'cart#products'

  resources :orders, only: [:create]
  resources :billing_addresses, only: [:create]

  # checkout 
  get 'checkout', to: 'checkout#index'
  post 'checkout', to: 'checkout#checkout'

  # cart
  get 'cart', to: 'cart#products'
  get 'thankyou', to: 'cart#thankyou'
  post 'cart_update', to: 'cart#cart_update'
  post 'remove_product', to: 'cart#remove_product'
end
