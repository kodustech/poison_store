Rails.application.routes.draw do
  resources :medication_requests, only: [:new, :create]
  root 'medication_requests#new'
end 