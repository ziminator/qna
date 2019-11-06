Rails.application.routes.draw do
  devise_for :users

  resources :questions, except: %i[edit update] do
    resources :answers, shallow: true, only: %i[create destroy update]
  end

  root to: 'questions#index'
end
