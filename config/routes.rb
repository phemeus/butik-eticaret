Rails.application.routes.draw do
  resource :session, only: [ :new, :create, :destroy ]
  resources :passwords, param: :token, only: [ :new, :create, :edit, :update ]
  resource :registration, only: [ :new, :create ]

  root "home#index"

  resources :categories, only: [ :index, :show ], param: :slug
  resources :products, only: [ :index, :show ], param: :slug

  resource :cart, only: [ :show ] do
    post :apply_coupon
    delete :remove_coupon
    resources :cart_items, only: [ :create, :update, :destroy ]
  end

  resources :stock_notifications, only: [ :create ]

  resources :addresses, except: [ :show ]
  resources :orders, only: [ :index, :show, :new, :create ]

  namespace :admin do
    root "dashboard#index"
    resources :categories
    resources :products do
      resources :product_variants, except: [ :index, :show ], shallow: true
    end
    resources :orders, only: [ :index, :show, :update ]
    resources :content_blocks, except: [ :show ]
    resource :site_settings, only: [ :edit, :update ]
    resources :reports, only: [ :index ]
    resources :coupons, except: [ :show ]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
