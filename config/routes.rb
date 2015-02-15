Rails.application.routes.draw do
  resources :styles

  resources :beer_clubs

  resources :users

  resources :beers

  resources :breweries

  resources :ratings, only: [:index, :new, :create, :destroy]

  resources :memberships, only: [:new, :create, :destroy]

  resource :session, only: [:new, :create, :delete]

  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'

  get 'places', to: 'places#index'
  post 'places', to: 'places#search'

  resources :places, only:[:index, :show]

  post 'places', to:'places#search'

  root 'breweries#index'

  resources :breweries do
    post 'toggle_activity', on: :member
  end

end
