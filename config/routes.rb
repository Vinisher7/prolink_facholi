Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by uptime monitors and load balancers.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'home#index'

  # Rotas para Ordens de Contingência (seguindo padrão RESTful)
  resources :contingencia_ordens, path: 'contingencia-ordens' do
    member do
      post :add_items
    end
    collection do
      get :fetch_products_by_line
      get :fetch_lines
    end
  end

  # Rotas para Produtos de Contingência (seguindo padrão RESTful)
  resources :contingencia_produtos, path: 'contingencia-produtos' do
    collection do
      get :fetch_unity_measurements
    end
  end

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

      # Mantendo namespace de contingência apenas para APIs externas (se necessário)
      namespace :contingencia do
        resources :contingencia_products, only: %i[create index]
        resources :contingencia_production_orders, only: %i[create index]
        resources :contingencia_model_items, only: %i[create index]
      end
    end
  end
end
