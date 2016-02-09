Rails.application.routes.draw do
  root 'checklists#index'
  resources :checklists

  namespace :api, defaults: {format: :json} do
    resources :checks, only: [:update, :destroy]
  end

end

