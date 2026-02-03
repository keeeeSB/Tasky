Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
  }
  devise_for :users, controllers: {
    sessions: 'users/sessions',
  }

  namespace :admins do
    root 'dashboards#index'
    resources :users, only: %i[index show destroy]
    resources :teams, only: %i[index show new edit create update destroy] do
      resources :team_invitations, only: %i[new create], module: :teams
    end
  end

  namespace :users do
    resource :team, only: %i[show] do
      resources :tasks, only: %i[show new edit create update destroy], module: :teams do
        member do
          patch :toggle
        end
      end
    end
  end

  resources :team_invitations, only: [] do
    collection do
      get :accept
    end
  end

  root 'static_pages#home'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  get 'up' => 'rails/health#show', as: :rails_health_check
end
