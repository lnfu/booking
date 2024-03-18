Rails.application.routes.draw do
  resources :time_slots, only: [ :index, :new, :delete, :destroy, :edit ]
  resources :rooms, only: [ :index ]
  resources :users, only: [ :index, :delete, :destroy ] do
    member do
      patch "upgrade_guest_to_regular"
      patch "downgrade_regular_to_guest"
      patch "upgrade_regular_to_admin"
      # patch "downgrade_admin_to_regular"
    end
  end
  resource :profile, controller: :profile, only: [ :show, :update ]

  # session
  get "/login", to: "session#new"
  post "/login", to: "session#create"
  get "/login/callback", to: "session#callback"
  delete "/logout", to: "session#destroy"
end
