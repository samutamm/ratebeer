Rails.application.routes.draw do
  resources :styles

  resources :beer_clubs

  resources :beers

  resources :ratings, only: [:index, :new, :create, :destroy]

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
  resources :users do
    post 'toggle_banned', on: :member
  end
  resources :memberships, only: [:new, :create, :destroy] do
    post 'confirm', on: :member
  end

  get 'beerlist', to:'beers#list'

  get 'ngbeerlist', to:'beers#nglist'

  get 'brewerylist', to:'breweries#list'

  get 'auth/:provider/callback', to: 'sessions#create_oauth'
end
