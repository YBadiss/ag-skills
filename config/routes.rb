Rails.application.routes.draw do
  get 'reset', to: 'summary#reset_to_test_state'

  resources :users, only: [:new, :create, :index]
  resources :skills, only: [:new, :create, :index]

  root 'summary#index'
end
