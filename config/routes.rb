Rails.application.routes.draw do

  resources :users, only: :create 
  resources :authentication, only: [:create, :show]

  post "wallet/new_transaction", to: "wallets#new_transaction"

end
