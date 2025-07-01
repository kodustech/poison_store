Rails.application.routes.draw do
  resources :medication_requests, only: [:new, :create]
  resources :reports, only: [] do
    collection do
      get :top_medications
    end
  end
  root 'medication_requests#new'
end 