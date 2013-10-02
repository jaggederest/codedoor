Codedoor::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root to: 'application#main'

  resources :programmers, only: [:index, :show]

  resources :users, only: [:edit, :update] do
    resource :programmer, only: [:edit, :update] do
      post :verify_contribution, defaults: { format: :json }
    end
    resource :client, only: [:new, :create, :edit, :update]
    resource :payment_info, only: [:edit] do
      # The balanced payments API scrubs _method, so :update must be a POST
      post :update, defaults: { format: :json }
    end
  end

  get '/terms', to: 'legal#terms'

end
