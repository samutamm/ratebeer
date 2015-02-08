class PlacesController < ApplicationController
  def index

  end

  def search
    url = 'http://stark-oasis-9187.herokuapp.com/api/'

    response = HTTParty.get "#{url}#{params[:city]}"
    @places = response.parsed_response["bmp_locations"]["location"].inject([]) do | set, place |
      set << Place.new(place)
    end
    render :index
  end
end