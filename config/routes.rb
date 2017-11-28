Rails.application.routes.draw do
  get 'sessions/new'

  root 'welcomes#index'
  resources :foods do
    collection do
      get 'export_pdf'
    end
  end

  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server_error'
  get '/help', to: 'users#help'
  get '/new_update', to: 'users#new_update'
  #get 'not_visible', to: 'home#not_visible'

  resources :users, only: [:show, :index, :edit, :update] do
    member do
      get 'select_menu'
      get 'select_dish'
      get 'order'
      get 'add_dish_to_order_no_ajax'
      get 'delete_today_order_session'
      get 'copy_order'
      post 'edit_note'
      post 'save_order'
      post 'add_dish'
      get 'change_password'
      patch 'confirm_change_password'
    end

    collection do
      get 'test'
      get 'get_all_orders_today'
      post 'test_ajax'
    end
  end

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/signup', to: 'foods#index'
  get 'restaurant/:id/new_dish', to: 'dishes#new'
  get 'orders/show_personal_orders', to: 'orders#show_personal_orders'

  resources :menus, only: [:show, :index] do
    collection do
      get 'request_menu'
    end
  end
  resources :restaurants, only: [:show, :index] do
    member do
      get 'show_detail'
    end
  end
  resources :dishes, only: [:show, :index]
  resources :pictures, only: [:show, :index, :new, :create]

  resources :managers do
    member do
      get 'add_menu_today'
      get 'manage_order'
      get 'manage_resource'
    end
  end

  resources :comments, only: [:new, :index, :create, :show]

  resources :tags

  namespace :admin do
    resources :menus
    resources :users do
      collection do
        get 'manage'
        get 'manage_company'
        get 'manage_all_days'
        get 'get_manage'
        post 'manage_all_days', to: 'users#manage_all'
        get 'export_manage_pdf'
        get 'scrap_data'
        get 'ping_slack'
        get 'add_initial_user'
      end
    end
    resources :dishes do
      collection do
        post 'new_tag'
      end
    end
    resources :restaurants do
      member do
        get 'show_image'
      end
      collection do
        get 'scrap_dish'
      end
    end
    resources :orders do
      collection do
        post 'ajax_get_dishes_by_date'
        get 'export_pdf'
      end
    end
    resources :pictures
    resources :comments
  end

  # The priority is based upon orders of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
