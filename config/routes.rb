Rails.application.routes.draw do
  devise_for :users
  root "static_pages#index"
  get "terms" => "static_pages#terms"
  get "support" => "static_pages#support"
  get "privacy" => "static_pages#privacy"

  get "users/deeplink/:signature" => "users#deeplink", as: :deeplink
end