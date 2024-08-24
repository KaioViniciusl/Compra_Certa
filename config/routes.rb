Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :groups do
    collection do
      get :all
    end
    member do
      get :accept_invite
      post :send_invite
    end
  end

  # Outras rotas
  get "up" => "rails/health#show", as: :rails_health_check
end
