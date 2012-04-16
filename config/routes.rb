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

    resources :users, :only => [:index, :create, :show, :update]

    post 'user_sessions' => 'user_sessions#create'

    get 'places/remote' => 'places#remote'
    get 'places' => 'places#index'

    get 'events/remote' => 'events#remote'
    get 'events/recommended' => 'events#recommended'

    resources :events, :only => [:index, :create, :show]

    resources :places, :only => [:create]

    post "places/:place_id/events" => "events#create"

    # Videos
    post 'events/:event_id/videos' => 'videos#create'
    get  'videos/:id' => 'videos#show'
    get  'videos'     => 'videos#index'
    put  'videos/:id' => 'videos#update'
    delete  'videos/:id' => 'videos#destroy'
    get  'events/:event_id/videos' => 'videos#index'
    get  'users/:user_id/videos' => 'videos#index'
    get  "songs/:song_id/videos" => "videos#index"
    get  "videos/:id/likes" => "videos#likes"

    constraints :commentable => /videos|places|events/ do
      get "/:commentable/:id/comments" => "comments#index", :as => :comment_create
      post "/:commentable/:id/comments" => "comments#create", :as => :comments_list
    end

    constraints :taggable => /videos|places|events/ do
      get "/:taggable/:id/tags" => "tags#index", :as => :create_tag
      post "/:taggable/:id/tags" => "tags#create", :as => :tags_list
    end

    # Songs
    get "/videos/:video_id/songs" => "songs#index", :as => :video_songs_list
    post "/videos/:video_id/songs" => "songs#create", :as => :create_song
    get "/songs" => "songs#index", :as => :songs_list
    get "/events/:event_id/songs" => "songs#index", :as => :event_songs_list

    get "users/:user_id/followings" => "relationships#followings"
    get "users/:user_id/followers" => "relationships#followers"

    # Likes
    get "users/:user_id/likes" => "likes#index"

    # me routes
    get 'me' => "users#show"
    put "/me/coordinates" => "users#update_coordinates"
    put 'me' => "users#update"
    get "me/followings" => "relationships#followings"
    get "me/followers" => "relationships#followers"
    post "me/followings" => "relationships#create"
    delete "me/followings/:user_id" => "relationships#destroy"
    get "me/likes" => "likes#index"
    post "me/likes" => "likes#create"
    delete "me/likes/:video_id" => "likes#destroy"
    get "me/videos" => "videos#index"
    get "me/provider_local_friends" => "users#provider_local_friends"
    get "me/provider_remote_friends" => "users#provider_remote_friends"

    #Authentications
    put    "/me/authentications/:provider" => "authentications#link"
    delete "/me/authentications/:provider" => "authentications#destroy"
  end

  resources :videos, :only => [:index, :new, :create, :destroy]

  post "/callbacks/demux"

  root :to => "videos#index"

end
