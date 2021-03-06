Rails.application.routes.draw do

  post 'pay2go/return'
  post 'pay2go/notify'

  scope :path => '/api/v1/', :module => "api_v1", :as => 'v1', :defaults => { :format => :json } do

    post "/login" => "auth#login"
    post "/logout" => "auth#logout"

    resources :events
  end

  resources :products do
    member do
      post :buy
      post :cancel
    end
  end

  resources :orders do
    member do
      post :checkout_pay2go
    end
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  get "/events/first" => "events#first"

  get "/ubikes" => "ubikes#ubikes_data"

  get "/ajax" => "ajaxtest#ajax"
  get "/ajaxtest" => "ajaxtest#ajaxtest"

  resources :events do
    resource :location, :controller => "event_locations"
    resources :attendees, :controller => "event_attendees"
    resources :likes

    member do
      post :subscribe
      post :unsubscribe
    end

    collection do
      get :latest

      post :bulk_update

    end
    member do
      get :dashboard
      post :join
      post :withdraw
    end
  end

  namespace :admin do
    resources :events # , :controller=> "admin::events"(是預設值可省略)
    resources :orders
  end



  resources :people


  get "/welcome/say_helliii" => "welcome#say"
  get "welcome" => "welcome#index"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end


end
