Rails.application.routes.draw do
  root "boards#index"

  resources :time_slots, only: [ :index, :create, :new, :delete, :destroy, :edit ]
  resources :rooms, only: [ :index ]
  resources :users, only: [ :index, :delete, :destroy ] do
    member do
      patch "upgrade_guest_to_regular"
      patch "downgrade_regular_to_guest"
      patch "upgrade_regular_to_admin"
      # patch "downgrade_admin_to_regular"
    end
  end
  resources :reservations, only: [ :index, :create, :delete, :destroy ]
  resource :profile, controller: :profile, only: [ :show, :update ]
  get "/boards", to: "boards#index", as: :board_main
  get "/boards/:id/:year/:month/:day", to: "boards#show",
    constraints: { year: /\d{4}/, month: /\d{1,2}/, day: /\d{1,2}/ },
    as: :board
  get "/boards/:id", to: "boards#show_today",
    as: :board_today

  # session
  get "/login", to: "session#new"
  post "/login", to: "session#create"
  get "/login/callback", to: "session#callback"
  delete "/logout", to: "session#destroy"
end
