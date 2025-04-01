Rails.application.routes.draw do
  # Routes publiques
  scope module: 'pages', as: 'public' do
    get 'about', to: 'pages#about'
    get 'contact', to: 'pages#contact'
    get 'privacy', to: 'pages#privacy'
    get 'terms', to: 'pages#terms'
    get 'privacy-policy', to: 'pages#privacy_policy'
    root to: 'pages#home'
  end

  # Routes d'authentification Devise
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  # Routes protégées
  authenticate :user do
    # Routes pour les dashboards
    get 'dashboard/manager', to: 'pages#dashboard_manager', as: :dashboard_manager
    get 'dashboard/user', to: 'pages#dashboard_user', as: :dashboard_user

    # Routes pour les guides et leurs ressources imbriquées
    resources :guides do
      member do
        get 'preview'
        get 'capture'
        post 'publish'
        post 'unpublish'
      end

      resources :steps, only: [:create, :update, :destroy] do
        collection do
          post 'reorder'
        end
      end

      resources :quizzes, only: [:create, :update, :destroy] do
        member do
          post 'submit'
        end
      end

      resources :guide_feedbacks, only: [:create, :update, :destroy]
    end

    # Routes pour les parcours
    resources :parcours do
      member do
        post 'publish'
        post 'unpublish'
      end
      resources :parcours_guides, only: [:create, :destroy] do
        collection do
          post 'reorder'
        end
      end
    end

    # Routes pour les demandes de prestation
    resources :service_requests, only: [:index, :new, :create, :show, :update] do
      member do
        post 'accept'
        post 'reject'
        post 'complete'
      end
    end

    # Routes pour les entreprises
    resources :enterprises, only: [:show, :edit, :update] do
      member do
        get 'dashboard'
        get 'analytics'
      end
    end

    # Routes pour les utilisateurs
    resources :users, only: [:index, :show, :edit, :update] do
      member do
        get 'profile'
        get 'guides'
        get 'parcours'
      end
    end
  end

  # Routes API pour l'extension Chrome
  namespace :api do
    namespace :v1 do
      # Authentification
      post 'auth/login', to: 'auth#login'

      # Guides
      resources :guides, only: [:index, :show, :create, :update, :destroy] do
        member do
          post 'capture'
        end
        resources :steps, only: [:create, :update, :destroy]
        resources :quizzes, only: [:create, :update, :destroy]
        resources :guide_feedbacks, only: [:create]
      end

      # Interactions
      resources :interactions, only: [:index, :create]
    end
  end

  # Routes pour le PWA
  get 'manifest.json', to: 'pwa#manifest'
  get 'service-worker.js', to: 'pwa#service_worker'
  get 'offline.html', to: 'pwa#offline'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
