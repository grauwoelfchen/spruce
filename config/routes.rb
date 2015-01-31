Spruce::Application.routes.draw do
  constraints format: "html" do
    # authentication
    delete :logout, to: "sessions#destroy", as: :logout
    get    :login,  to: "sessions#new",     as: :login
    post   :login,  to: "sessions#create"

    # signup & activation
    get  :signup, to: "users#new", as: :signup
    post :signup, to: "users#create"
    get "/users/:token/activate", to: "users#activate", as: :activate,
      constraints: {token: /[A-z0-9]+/}

    # reset password
    resources :password_resets,
      param:  :token,
      except: [:index, :show, :destroy],
      constraints: {token: /[A-z0-9]+/}

    # versions
    constraints id: /[0-9]+/, type: /b|l/ do
      get  "/v/:id/:type/revert", to: "versions#revert", as: :revert_version,
        constraints: RevertConstraint.new
      post "/v/:id/:type/revert", to: "versions#restore",
        constraints: RevertConstraint.new
    end

    # pages
    get :introduction, to: "pages#introduction"
    get :changelog,    to: "pages#changelog"
    get :syntax,       to: "pages#syntax"
  end

  # nodes and notes
  constraints id: /[0-9]+/ do
    constraints format: /html|txt/ do
      resources :nodes, path: "b", shallow: true, only: :index
    end

    resources :nodes, path: "b", shallow: true, only: :none do
      constraints format: "html" do
        resources :nodes, path: "b",
          except: [:index, :destroy, :show], with: [:delete]
        resources :notes, path: "l",
          except: [:index, :destroy, :show], with: [:delete]
      end

      constraints format: /html|txt/ do
        resources :nodes, path: "b", only: [:show]
        resources :notes, path: "l", only: [:show]
      end
    end
  end

  constraints format: "xml" do
    get :sitemap, to: "sitemap#index"
  end

  root "pages#index"
end
