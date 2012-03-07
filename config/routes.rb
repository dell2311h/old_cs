Crowdsync::Application.routes.draw do

devise_for :users, :path_names => { :sign_up => "register" }

  namespace :api do
    post 'users' => 'users#create'
    get 'users/:id' => 'users#show'
    put 'users/:id' => 'users#update'

    post 'user_sessions' => 'user_sessions#create'

    get 'places' => 'places#index'

    get 'events' => 'events#index'
    
    resources :events, :only => [:create]
    
    post "places/:place_id/events" => "events#create"

    resources :places, :only => [] do
      collection do
        get 'list_by_name'
        get 'nearby'
      end
    end

    #videos
    post 'videos'     => 'videos#create'
    get  'videos/:id' => 'videos#show'
    get  'videos'     => 'videos#index'
    put  'videos/:id' => 'videos#update'

  end
end
