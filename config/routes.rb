Rails.application.routes.draw do
  resources :users

  resources :beers

  resources :breweries

  resources :ratings, only: [:index, :new, :create, :destroy]

  get 'signup', to: 'users#new'

  root 'breweries#index'

  # get 'kaikki_bisset', :to => 'beers#index'
  # get 'ratings/new', :to => 'ratings#new'
  # post 'ratings', :to => 'ratings#create'
  #
  # get 'ratings', to: 'ratings#index'

end
