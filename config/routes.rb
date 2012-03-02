Crowdsync::Application.routes.draw do
  
  namespace :api do
    resources :events, :only => [:index] do
      collection do
        get 'top'
      end
    end
    
    resources :places, :only => [] do
      collection do
        get 'list_by_name'
        get 'nearby'
      end
    end
  end
end
