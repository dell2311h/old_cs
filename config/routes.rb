Crowdsync::Application.routes.draw do

  namespace :api do   
    post 'registration' => 'registrations#create'
   
    get 'places' => 'places#index'
    
    get 'events' => 'events#index'
    
  end
end
