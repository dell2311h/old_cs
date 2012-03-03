Crowdsync::Application.routes.draw do

  namespace :api do
    resource :users, :only => [:create, :update, :show]

    get 'places' => 'places#index'

    get 'events' => 'events#index'

  end
end
