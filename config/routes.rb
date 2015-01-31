Rails.application.routes.draw do
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

  root 'breweries#index'

  # get 'kaikki_bisset', :to => 'beers#index'
  # get 'ratings/new', :to => 'ratings#new'
  # post 'ratings', :to => 'ratings#create'
  #
  # get 'ratings', to: 'ratings#index'

end
