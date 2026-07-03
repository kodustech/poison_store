Rails.application.routes.draw do
  resources :medication_requests, only: [:new, :create]
  
  resources :over_the_counter_medications do
    resources :stock_movements, only: [:index, :new, :create]
    resources :medication_batches, only: [:index, :new, :create]
  end
  resources :medication_sales

  get 'stock_dashboard', to: 'stock_movements#dashboard'

  resources :medication_batches, only: [] do
    collection do
      get :expiring
      post :quarantine_expired
    end
  end

  resources :loyalty_accounts do
    member do
      patch :redeem
    end
  end

  resources :restock_orders do
    member do
      patch :submit
      patch :receive
      patch :cancel
    end
  end

  # Autenticação de operadores
  get  'login',  to: 'sessions#new'
  post 'login',  to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :operators do
    member do
      post :reset_token
    end
  end
  
  resources :medical_professionals do
    collection do
      get :search_by_crm
    end
  end
  
  resources :laboratories
  
  resources :reports, only: [:index] do
    collection do
      get :top_medications
      get :search_doctors
    end
  end
  
  get 'monthly_sales_report', to: 'monthly_sales_report#index'
  get 'activity_report', to: 'activity_report#index'

  root 'medication_requests#new'
end 