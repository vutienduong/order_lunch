Rails.application.routes.draw do
  get 'sessions/new'

  root 'users#index'
  resources :foods do
    collection do
      get 'export_pdf'
    end
  end

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

  resources :managers do
    member do
      get 'add_menu_today'
      get 'manage_order'
      get 'manage_resource'
    end
  end

  namespace :admin do
    resources :menus
    resources :users do
      collection do
        get 'manage'
        get 'manage_company'
        get 'manage_all_days'
        get 'get_manage'
        post 'manage_all_days', to: 'users#manage_all'

      end
    end
    resources :dishes
    resources :restaurants do
      member do
        get 'show_image'
      end
    end
    resources :orders do
      collection do
        post 'ajax_get_dishes_by_date'
      end
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
