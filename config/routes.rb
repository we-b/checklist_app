Rails.application.routes.draw do
  root 'checklists#index'
  resources :checklists
end

