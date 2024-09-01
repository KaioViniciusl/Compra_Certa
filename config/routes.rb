Rails.application.routes.draw do
  devise_for :users, controllers: {
                       sessions: "users/sessions",
                       registrations: "users/registrations",
                     }

  root to: "pages#home"

  resources :groups do
    resources :expenses
    resources :expense_payers, only: [:new, :create]
  end

  # Outras rotas
  get "up" => "rails/health#show", as: :rails_health_check
end
