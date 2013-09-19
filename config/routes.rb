Codedoor::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root to: 'application#main'

  resources :programmers, only: [:index, :show]

  resources :users, only: [:edit, :update] do
    resource :programmer, only: [:edit, :update] do
      post :verify_contribution, defaults: { format: :json }
    end
    resource :payment_info, only: [:new, :create, :edit, :update]
  end

end
