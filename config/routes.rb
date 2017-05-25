Rails.application.routes.draw do
  resources :spaces
  post '/pawns/awaken'
  post '/pawns/move'
  # resources :pawns

  get 'pages/welcome', as: :welcome
  get 'pages/about', as: :about
  get 'pages/home', as: :home
  root to: 'pages#welcome'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
