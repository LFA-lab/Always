Rails.application.routes.draw do
  devise_for :users
  get "service_requests/new"
  get "service_requests/create"
  get "service_requests/show"
  get "parcours_guides/create"
  get "parcours_guides/update"
  get "parcours_guides/destroy"
  get "parcours/index"
  get "parcours/show"
  get "parcours/new"
  get "parcours/edit"
  get "parcours/create"
  get "parcours/update"
  get "parcours/destroy"
  get "guide_feedbacks/new"
  get "guide_feedbacks/create"
  get "quizzes/show"
  get "quizzes/new"
  get "quizzes/create"
  get "quizzes/update"
  get "quizzes/destroy"
  get "steps/create"
  get "steps/update"
  get "steps/destroy"
  get "users/index"
  get "users/show"
  get "users/new"
  get "users/edit"
  get "users/create"
  get "users/update"
  get "users/destroy"
  get "enterprises/index"
  get "enterprises/show"
  get "enterprises/new"
  get "enterprises/edit"
  get "enterprises/create"
  get "enterprises/update"
  get "enterprises/destroy"
  get "guides/index"
  get "guides/show"
  get "guides/new"
  get "guides/edit"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
