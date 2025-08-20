Rails.application.routes.draw do
  resources :medication_requests, only: [:new, :create]
  
  resources :over_the_counter_medications
  resources :medication_sales
  
  resources :reports, only: [:index] do
    collection do
      get :top_medications
      get :search_doctors
    end
  end
  
  get 'monthly_sales_report', to: 'monthly_sales_report#index'
  
  root 'medication_requests#new'
end 