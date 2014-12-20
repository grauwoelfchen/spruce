Spruce::Application.routes.draw do
  # authentication
  delete :logout, to: "sessions#destroy", as: :logout
  get    :login,  to: "sessions#new",     as: :login
  post   :login,  to: "sessions#create"

  # signup & activation
  get  :signup, to: "users#new", as: :signup
  post :signup, to: "users#create"
  get "users/:token/activate", to: "users#activate", as: :activate,
    constraints: {token: /[A-z0-9]+/}

  # reset password
  resources :password_resets,
    param:  :token,
    except: [:index, :show, :destroy]

  resources :nodes, path: "b", shallow: true, only: [:index] do
    options = {
      except: [:index, :destroy],
      with: [:delete]
    }
    resources :nodes, {path: "b"}.merge(options)
    resources :notes, {path: "l"}.merge(options) do
      get :show, constraints: {format: %w(html txt)}
    end
  end

  # versions
  get  "v/id/type/revert", to: "versions#revert", as: :revert_version,
    constraints: RevertConstraint.new
  post "v/id/type/revert", to: "versions#restore",
    constraints: RevertConstraint.new

  # pages
  get :introduction, to: "pages#introduction"
  get :changelog,    to: "pages#changelog"
  get :syntax,       to: "pages#syntax"

  get :sitemap, to: "sitemap#index", constraints: {format: "xml"}

  # errors
  match ":code", to: "errors#show", via: :all, constraints: {code: /\d{3}/ }

  root "pages#index"
end
