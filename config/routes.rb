Rails.application.routes.draw do
  resources :period_cost_phases
  resources :costs
  resources :periods
  resources :quantities
  resources :lots
  resources :product_treatments
  resources :product_treatment_phases
  resources :phases
  resources :treatments
  resources :products

  
  post '/product_quantities/', to: 'products#quantity'
  post '/product_quantities/detail', to: 'products#quantity_detail'
  post '/phase_quantities/', to: 'products#quantity_phase'
  get '/pull_quantities/', to: 'products#quantity_pull'
  post 'product_treatment_phases/classification', to: 'product_treatment_phases#classification'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
