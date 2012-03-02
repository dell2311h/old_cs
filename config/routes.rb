Crowdsync::Application.routes.draw do

  namespace :api do   
    post 'registration' => 'registrations#create'
   
    get 'places' => 'places#index'
    
    get 'events' => 'events#index'
    get 'events' => 'events#top'
    
  end
end
