Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "login", to: "sessions#create"

      resources :customers, only: [] do
        get "current", on: :collection
        resources :ie_statements, only: [ :create ]
      end

      resources :ie_statements, only: [] do
        resources :incomes, only: [ :create ]
        resources :expenditures, only: [ :create ]
      end
    end
  end
end
