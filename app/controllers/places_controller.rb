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
        render :index
      end
    end
  end
end