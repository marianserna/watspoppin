Rails.application.routes.draw do

  root 'pages#main'

  get '/stories/new' => 'stories#new'
  post '/stories' => 'stories#create'

end
