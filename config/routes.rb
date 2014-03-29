Spruce::Application.routes.draw do
  # authentication
  delete "logout" => "sessions#destroy", :as => :logout
  get    "login"  => "sessions#new",     :as => :login
  post   "login"  => "sessions#create"

  # signup & activation
  get  "signup" => "users#new", :as => :signup
  post "signup" => "users#create"
  get "users/:token/activate",
    :to          => "users#activate",
    :as          => :activate,
    :constraints => {:token => /[A-z0-9]+/}

  # reset password
  resources :password_resets, :param => :token, :except => [:index, :show, :destroy]

  resources :nodes, :path => "b", :shallow => true, :only => [:index] do
    resources :nodes, :path => "b", :except => [:index], :with => [:delete]
    resources :notes, :path => "l", :except => [:index], :with => [:delete]
  end

  # versions
  post "v/:id/:type/revert" => "versions#revert",
    :as          => "revert_version",
    :constraints => {:type => /b|l/}

  # pages
  get "introduction", :to => "pages#introduction"
  get "changelog",    :to => "pages#changelog"

  root "pages#index"
end
