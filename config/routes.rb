Rails.application.routes.draw do
  devise_for :users, controllers: {
                       sessions: "users/sessions",
                       registrations: "users/registrations",
                     }

  root to: "pages#home"

  resources :groups do
    resources :expenses
  end

  # Outras rotas
  get "up" => "rails/health#show", as: :rails_health_check
end
