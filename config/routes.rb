Rails.application.routes.draw do
  get 'home', to: 'home#index'
  resources :timestamps
  resources :tokens, only: [:index, :new, :create] do
    collection do
      get :transfer, to: 'tokens#new'
      post :transfer
    end
  end
  root "home#index"
end
