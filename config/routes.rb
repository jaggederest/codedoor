Codedoor::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root to: 'application#main'

  # Not part of the :contractors resources, because you can only edit yourself (May change with admin accounts)
  get '/contractors/edit', to: 'contractors#edit', as: :edit_contractor
  resources :contractors, only: [:index, :show, :new, :create, :update]
end
