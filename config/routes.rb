Rails.application.routes.draw do
  resources :quantities
  resources :lots
  resources :product_treatments
  resources :product_treatment_phases
  resources :phases
  resources :treatments
  resources :products

  
  get '/product_quantities/', to: 'products#quantity'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
