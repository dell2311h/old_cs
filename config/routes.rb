Crowdsync::Application.routes.draw do

  namespace :api do
    post 'users' => 'users#create'
    get 'users/:id' => 'users#show'
    put 'users/:id' => 'users#update'

    post 'user_sessions' => 'user_sessions#create'

    get 'places' => 'places#index'

    get 'events' => 'events#index'

  end
end
