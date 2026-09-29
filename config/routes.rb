Rails.application.routes.draw do
  # Auth (rails g authentication)
  resource :session
  resources :passwords, param: :token

  root "today#show"

  resources :moments, only: %i[new create update]
  get "calendario" => "calendar#index", as: :calendar
  get "dias/:date" => "days#show", as: :day
  resource :nosotros, only: %i[show update], controller: "us", as: :us

  get "up" => "rails/health#show", as: :rails_health_check

  # PWA
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
