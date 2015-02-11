class BeermappingApi

  def self.places_in(city)
    city = city.downcase
    result = Rails.cache.fetch(city, :expires_in => 1.week) { fetch_places_in(city) }
    #session[:last_search] = result
    result
  end

  def self.fetch_places_in(city)
    #url = 'http://stark-oasis-9187.herokuapp.com/api/'
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.inject([]) do | set, place |
      set << Place.new(place)
    end
  end

  def self.key
    '3fe9417dccf6f093bfb739b6bc00ed7a'
  end
end

#"http://beermapping.com/webservice/loccity/3fe9417dccf6f093bfb739b6bc00ed7a/"