Rails.application.routes.draw do
  mount OrderLunchAPI => '/api'

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
      post 'copy_ajax'
      post 'post_copy_ajax'
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
  resources :orders do
    collection do
      get 'order_custom_salad'
      post 'order_custom_salad', to: 'orders#create_custom_salad'
      get 'confirm_create_same_combo'
      post 'check_custom_salad_name'
      post 'add_dish_to_order'
      post 'create_custom_salad_with_name'
      get 'custom_order'
      post 'create_custom_order'
    end
  end

  resources :notices, only: [:index, :show]

  namespace :admin do
    get 'select_dish_for_provider/:id' => 'providers#select_dish_for_provider',
        as: :select_dish_for_provider

    post 'select_dish_for_provider' => 'providers#confirm_dish_for_provider',
        as: :confirm_dish_for_provider

    get 'quick_add_dishes' => 'providers#quick_add_dishes', as: :quick_add_dishes

    post 'quick_add_dishes' => 'providers#save_quick_add_dishes'

    get 'quick_add_with_type' => 'providers#quick_add_with_type', as: :quick_add_with_type

    post 'quick_add_with_type' => 'providers#save_quick_add_with_type'

    get 'set_menu_for_month' => 'providers#set_menu_for_month', as: :set_month_menu

    post 'select_date_to_set' => 'providers#select_date_to_set', as: :select_date_to_set

    get 'add_provider_for_month' => 'providers#add_provider_for_month', as: :add_provider_for_month

    post 'add_provider_for_month' => 'providers#post_add_provider_for_month'

    get 'default_provider_menu_day' =>
        'providers#default_provider_menu_day'

    post 'default_provider_menu_day' =>
        'providers#post_default_provider_menu_day'

    post 'confirm_add_dish_for_provider_daily' =>
        'providers#confirm_add_dish_for_provider_daily'

    resources :menus do
      member do
        get 'lock'
        get 'open'
        get 'lock_restaurants'
        post 'lock_restaurants' => 'menus#post_lock_restaurants'
      end

      collection do
        post 'lock_option'
      end
    end

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
        get 'retrieve_unordered_user'
        get 'export_orders_to_csv'
        get 'sap_page'
        post 'sap_page', to: 'users#post_sap_page'
      end
    end

    resources :dishes do
      collection do
        post 'new_tag'
        get 'import_page'
        post 'import'
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

    resources :new_providers do
      member do
        get 'add_dishes'
      end

      collection do
        get 'group_add_dishes'
        post 'group_add_dishes', to: 'new_providers#post_group_add_dishes'
        post 'get_dishes_of_date'
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
    resources :notices
    resources :ol_settings do
    end
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
