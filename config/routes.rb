Rails.application.routes.draw do
  devise_for :users, controllers: {
                       sessions: "users/sessions",
                       registrations: "users/registrations",
                     }

  root to: "pages#home"

  resource :settings, only: [:show, :update]

  resources :groups do
    resources :expenses
    resources :expense_payers, only: [:new, :create]
    member do
      get "accept_invite/:token", to: "groups#accept_invite", as: :accept_invite
    end
  end

  # Outras rotas
  get "up" => "rails/health#show", as: :rails_health_check
end
