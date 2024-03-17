Rails.application.routes.draw do
  resources :time_slots, only: [ :index, :new, :delete, :destroy, :edit ]
end
