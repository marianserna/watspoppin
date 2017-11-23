Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  root 'pages#main'

  get '/stories/new' => 'stories#new'
  post '/stories' => 'stories#create'

end
