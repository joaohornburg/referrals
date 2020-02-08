Rails.application.routes.draw do
  resources :users do
    resources :referrals, only: [:index]
  end

  post 'auth/login', to: 'authentication#login'
end
