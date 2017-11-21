Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  root to: 'pages#main'
end
