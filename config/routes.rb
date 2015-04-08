Rails.application.routes.draw do
  resources :tags, only: [:create]
  get "/tags/:taggable_type/:taggable_id" => "tags#show"
  delete "/tags/:taggable_type/:taggable_id" => "tags#destroy"
end
