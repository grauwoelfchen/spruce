Ash::Application.routes.draw do
  # authentication
  get  "logout" => "sessions#destroy", :as => :logout
  get  "login"  => "sessions#new", :as => :login
  post "login"  => "sessions#create"
  get  "signup" => "users#new", :as => :signup
  post "signup" => "users#create"

  resources :notes

  root "pages#index"
end
