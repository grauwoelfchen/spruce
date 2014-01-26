Ash::Application.routes.draw do
  resources :notes

  root "pages#index"
end
