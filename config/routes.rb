Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :posts, only: %i[index create] do
    get 'like'
    get 'repost'
  end

  resources :users

  root to: 'posts#index'
end
