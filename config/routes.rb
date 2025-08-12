Rails.application.routes.draw do
  resources :medication_requests, only: [:new, :create]
  resources :reports, only: [:index] do
    collection do
      get :top_medications
      get :search_doctors
    end
  end
  root 'medication_requests#new'
end 