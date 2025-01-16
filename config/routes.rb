Rails.application.routes.draw do
  root "companies#index"
  get "companies/search", to: "companies#search"

  namespace :admin do
    resources :companies, only: [:index] do
      collection do
        post :import
      end
    end
  end

  # Mount Action Cable for WebSocket connections
  mount ActionCable.server => '/cable'
end
