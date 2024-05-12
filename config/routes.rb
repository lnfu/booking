Rails.application.routes.draw do
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
    # Can be used by load balancers and uptime monitors to verify that the app is live.
    get "up" => "rails/health#show", as: :rails_health_check

    # Defines the root path route ("/")
    # root "posts#index"
    root to: "boards#index"

    resource :profile, controller: :profile, only: [ :show, :update ]
    resources :reservations, only: [ :index, :create, :delete, :destroy ]
    resources :time_slots, only: [ :index, :create, :new, :destroy, :edit ]
    resources :rooms, only: [ :index, :create, :new, :destroy, :edit, :update ]
    resources :users, only: [ :index, :create, :new, :destroy ] do
        member do
            patch "promote_to_regular"
            patch "promote_to_admin"
            patch "demote_to_guest"
        end
        resources :reservations
    end
    get "pending", to: "users#pending"
    get "/login", to: "session#new"
    post "/login", to: "session#create"
    get "/login/callback", to: "session#callback"
    delete "/logout", to: "session#destroy"  

    get "/boards/:id/(:date)", to: "boards#show",
        constraints: { :date => /\d{4}-\d{2}-\d{2}/ },
        as: :board

    get :rules, to: "rules#index" 
    get :limits, to: "limits#index" 
    put :limits, to: "limits#update" 
    
    # 忘記密碼
    get "/forgot-password", to: "users#forgot_password_form"
    post "/forgot-password", to: "users#forgot_password"
    get "/reset-password", to: "users#reset_password_form"
    post "/reset-password", to: "users#reset_password"

    delete '/users/:id/clear_reservations', 
        to: 'users#clear_reservations', 
        as: 'clear_reservations'

end
