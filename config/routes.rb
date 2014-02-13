Spruce::Application.routes.draw do
  # authentication
  delete "logout" => "sessions#destroy", :as => :logout
  get    "login"  => "sessions#new",     :as => :login
  post   "login"  => "sessions#create"

  # signup & activation
  get  "signup" => "users#new", :as => :signup
  post "signup" => "users#create"
  get "users/:token/activate", \
    :to          => "users#activate",
    :as          => :activate,
    :constraints => { :token => /[A-z0-9]+/ }

  resources :nodes
  resources :notes

  root "pages#index"
end
