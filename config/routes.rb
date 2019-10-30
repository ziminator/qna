Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, except: %i[edit update] do
    resources :answers, only: %i[create destroy], shallow: true
  end
end
