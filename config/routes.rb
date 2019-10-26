Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

#  resources :questions do
#    resources :answers, shallow: true, expect: %i[index show]

  resources :questions, except: %i[edit update] do
    resources :answers, only: %i[create destroy], shallow: true
  end
end
