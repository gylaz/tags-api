Rails.application.routes.draw do
  resources :tags, only: [:create]
end
