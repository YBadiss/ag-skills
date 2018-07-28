Rails.application.routes.draw do
  resources :users
  resources :skills

  root 'summary#index'
end
