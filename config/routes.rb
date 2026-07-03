Rails.application.routes.draw do
  resources :medication_requests, only: [:new, :create]
  
  resources :over_the_counter_medications do
    resources :stock_movements, only: [:index, :new, :create]
  end
  resources :medication_sales

  get 'stock_dashboard', to: 'stock_movements#dashboard'

  resources :restock_orders do
    member do
      patch :submit
      patch :receive
      patch :cancel
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