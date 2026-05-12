Rails.application.routes.draw do
  resources :medication_requests, only: [:new, :create]
  
  resources :over_the_counter_medications
  resources :medication_sales
  
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
  get 'sobre', to: 'about#index'
  get 'faq', to: 'faq#index'

  root 'medication_requests#new'

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_error', via: :all

  match '*unmatched_route', to: 'errors#not_found', via: :all
end 