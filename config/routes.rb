Rails.application.routes.draw do
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
    # Can be used by load balancers and uptime monitors to verify that the app is live.
    get "up" => "rails/health#show", as: :rails_health_check

    # Defines the root path route ("/")
    # root "posts#index"

    resources :time_slots, only: [ :index, :create, :new, :destroy, :edit ]
    resources :rooms, only: [ :index, :create, :new, :destroy, :edit ]
    resources :users, only: [ :index, :create, :new, :destroy ] do
        # member do
        # patch "upgrade_guest_to_regular"
        # patch "downgrade_regular_to_guest"
        # patch "upgrade_regular_to_admin"
        # patch "downgrade_admin_to_regular"
        # end
    end
end
