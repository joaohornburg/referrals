Rails.application.routes.draw do
  resources :users do
    resources :referrals, only: [:index]
  end
end
