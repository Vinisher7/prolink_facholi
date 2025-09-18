Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by uptime monitors and load balancers.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'home#index'

  # Home routes para funcionalidades de contingência
  get '/fetch_lines_data', to: 'home#fetch_lines_data'
  get '/fetch_products_by_line', to: 'home#fetch_products_by_line'
  post '/create_contingencia_order', to: 'home#create_contingencia_order'
  post '/add_items_to_order', to: 'home#add_items_to_order'
  get '/list_contingencia_orders', to: 'home#list_contingencia_orders'

  # Produtos de contingência
  post '/create_contingencia_product', to: 'home#create_contingencia_product'
  get '/list_contingencia_products', to: 'home#list_contingencia_products'
  get '/list_unity_measurements', to: 'home#list_unity_measurements'

  namespace :api do
    namespace :v1 do
      resources :erp_products, only: %i[create index] do
        collection do
          get :fetch_products_by_cod_linha
        end
      end
      resources :erp_unity_measurements, only: %i[create index]
      resources :erp_model_general, only: %i[create index]
      resources :erp_model_items, only: %i[create index]
      resources :erp_operation_general, only: %i[create index]
      resources :erp_operation_items, only: %i[create index]
      resources :erp_production_orders, only: %i[create index]
      resources :erp_reason_stops, only: %i[create index]
      resources :erp_stop_groups, only: %i[create index]
      resources :erp_shifts, only: %i[create index]
      resources :erp_equipments, only: %i[create index]
      resources :lines, only: [:index]

      namespace :contingencia do
        resources :contingencia_products, only: %i[create index]
        resources :contingencia_production_orders, only: %i[create index]
        resources :contingencia_model_items, only: %i[create index]
      end
    end
  end
end
