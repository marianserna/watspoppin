Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}

  root 'pages#main'

  resources :stories, only: [:new, :create] do
    resources :likes, module: :story
    collection do
      get :search
    end
  end

end
