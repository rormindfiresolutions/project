Rails.application.routes.draw do
  devise_for :users, controllers:{
    registrations: 'registrations',
    sessions: 'sessions',
    confirmations: 'confirmations',
    passwords: 'passwords',
    unlocks: 'unlocks'
  }

  root 'users#home'

  resources :users do
    collection do
      resources :orders, only: [:show, :index, :edit, :destroy] do
        get 'cancel_order', to: 'orders#cancel_order'
        get 'revert_order_state', to: 'orders#revert_order_state'
      end
      
      resources :user_profiles, only: [:new, :create]

      post :search_shop
      get :about
      get :contact
      get :easy_registration

      resources :shop_profiles, only: [:new, :create, :index, :show] do
        get :edit, on: :member
        put :update, on: :member
        resources :shipping_charges, only: [:new, :create, :edit, :update] do
          get :reset, on: :collection
        end  
        resources :shop_products do
          post :add_product_manually,to: 'shop_products#add_product_manually',on: :collection
        end
      end

      resources :addresses, only: [:new, :create, :edit, :update, :index] 

      get 'profile', to: 'users#profile'

      resources :user_baskets, only: [:edit, :update, :destroy] do
        get :create, on: :member
        get :edit_quantity ,on: :member
        put :update_quantity , on: :member
      end
    end
  end

  resources :products do
    get :show_image, on: :collection
    get :index
    get :product_index, on: :collection
    put :change_status
    put :change_activation_status

  end

  resources :shop_profiles do
    put :change_status
    get :shop_index, on: :collection
  end

  resources :order_lines, only: [:new, :create]
  resources :shop_inventory_details , only: [:new , :create, :index]
  get 'change_order_state' ,to: 'orders#change_order_state'
  get 'show_image', to: 'shop_products#show_image'

  resources :shipping_charges, only: [:destroy]

end