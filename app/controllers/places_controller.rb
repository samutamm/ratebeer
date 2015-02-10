class PlacesController < ApplicationController
  def index

  end

  def search
    city = params[:city]
    if city.empty?
      redirect_to places_path, notice: "Please give the name of city."
    else
      @places = BeermappingApi.places_in(city)
      if @places.empty?
        redirect_to places_path, notice: "No locations in #{city}"
      else
        session[:last_search] = nil
        session[:last_search] = city
        render :index
      end
    end
  end

  def show
    city = session[:last_search]
    places = BeermappingApi.places_in(city)
    id = params[:id]
    places.each do |place|
      if place.id == id
        @place = place
      end
    end
  end
end