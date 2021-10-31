Rails.application.routes.draw do
  resources :follows
  resources :posts
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "main", to: "users#login_page"
  post "main", to: "users#recieve_login_info", as: "recieve_login_info"
  get "feed", to: "users#feed"
  get "profile/:name", to: "users#view_profile"
  post "profile/:name", to: "users#follow_info", as: "recieve_follow_info"
  delete "profile/:name", to: "users#unfollow_info", as: "recieve_unfollow_info"
  post "like", to: "users#likepost"
  post "unlike", to: "users#unlikepost"
end
