Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  root 'pages#main'

  resources :stories, only: [:new, :create] do
    collection do
      get :search
    end
  end

end
