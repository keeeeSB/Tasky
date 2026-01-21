Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
  }
  devise_for :users

  namespace :admins do
    root 'dashboards#index'
    resources :teams, only: %i[index show new edit create update destroy]
  end

  root 'static_pages#home'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  get 'up' => 'rails/health#show', as: :rails_health_check
end
