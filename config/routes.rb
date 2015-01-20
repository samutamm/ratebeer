Rails.application.routes.draw do
  resources :beers

  resources :breweries

  resources :ratings, only: [:index, :new, :create, :destroy]

  root 'breweries#index'

  # get 'kaikki_bisset', :to => 'beers#index'
  # get 'ratings/new', :to => 'ratings#new'
  # post 'ratings', :to => 'ratings#create'
  #
  # get 'ratings', to: 'ratings#index'

end
