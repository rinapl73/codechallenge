Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :user_sessions, only: [:new, :create, :destroy]
  resources :uploads, only: [:index] do
    collection { post :import }
  end
  
  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout

  root 'welcome#index'

end
