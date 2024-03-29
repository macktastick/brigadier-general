Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :posts, only: [:show, :index]
  resources :subreddits, only: [:show, :index]

  root 'subreddits#index'

  post 'posts', to: 'posts#index'

  get ':reddit_id', to: 'posts#show_from_reddit_id'

end
