Crowdsync::Application.routes.draw do

devise_for :user, :path => '', :skip => [:registration] do
    scope :controller => 'devise/registrations' do      
      get :cancel, :path => 'users/cancel', :as => :cancel_user_registration
      post :create,  :path => 'sign_up', :as => :user_registration
      get  :new,     :path => 'sign_up' , :as => :new_user_registration
      get :edit,    :path => 'users/edit', :as => :edit_user_registration
      put :update, :path => 'users/edit', :as => :update_user_registration
      delete :destroy, :path => 'users'
    end
  end 

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
