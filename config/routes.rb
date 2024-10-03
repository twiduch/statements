Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "login", to: "sessions#create"
      get "customers/current", to: "customers#current"
    end
  end
end
