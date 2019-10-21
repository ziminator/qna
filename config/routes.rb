Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true, expect: %i[index show]
  end

  root to: 'questions#index'
end
