class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  has_many :ratings
  has_many :memberships
  has_many :beers, through:  :ratings
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true
  validates :username, length: { minimum: 3,
                                 maximum: 15 }
  validates_format_of :password, :with => /\A^(?=.*?[A-Z])(?=.*?[0-9]).{4,}$\Z/i

  def to_s
    "#{self.username}"
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.sort_by{ |r| r.score }.last.beer
  end

  def favorite_style
    max = 0
    favorite = nil
    rated_styles.each do |style|
      avg = avg_rating(ratings_for_style(style))
      if max < avg
        max = avg
        favorite = style
      end
    end
    favorite
  end

  def favorite_brewery
    max = 0
    favorite = nil
    rated_breweries.each do |brewery|
      avg = avg_rating(ratings_for_brewery(brewery))
      if max < avg
        max = avg
        favorite = brewery
      end
    end
    Brewery.find_by id: favorite
  end

  private
  def ratings_for_style(style)
    ratings.joins(:beer).where("beers.style = ?", style)
  end

  def ratings_for_brewery(brewery)
    ratings.joins(:beer).where("beers.brewery_id = ?", brewery)
  end

  def avg_rating(ratings)
    ratings.map { |rating| rating.score }.sum / ratings.count
  end
  def rated_styles
    beers.select(:style).distinct.map { |beer| beer.style}
  end
  def rated_breweries
    beers.select(:brewery_id).distinct.map { |beer| beer.brewery_id}
  end
end
