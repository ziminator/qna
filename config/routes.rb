Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

#  resources :questions, except: %i[edit update] do
  resources :questions do
    resources :answers, shallow: true, only: %i[create destroy update] do
      patch :best, on: :member
    end
  end
end
