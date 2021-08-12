require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  match 'users/:id/finish_sign_up', to: 'users#finish_sign_up', via: [:get, :patch], as: :finish_sign_up

  root to: 'questions#index'

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
    end
  end

  concern :commentable do
    resources :comments, only: :create
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, shallow: true, only: %i[create update destroy], concerns: %i[votable commentable] do
      patch 'select_best', on: :member
    end
  end

  resources :files, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :awards, only: %i[index]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[index show create update destroy], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
