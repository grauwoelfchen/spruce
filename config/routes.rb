Ash::Application.routes.draw do
  resources :sessions, :only => [:new, :create, :destroy]
  resources :users,    :only => [:new, :create]

  # authentication
  get "login"  => "sessions#new",     :as => :login
  get "logout" => "sessions#destroy", :as => :logout
  get "signup" => "users#new", :as => :signup

  resources :notes

  root "pages#index"
end
