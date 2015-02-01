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
    styles = rated_styles
    styles.each do |style|
      ratings_for_style = ratings.joins(:beer).where("beers.style = ?", style)
      avg = avg_rating(ratings_for_style)
      if max < avg
        max = avg
        favorite = style
      end
    end
    favorite
  end

  private
  def avg_rating(ratings)
    ratings.map { |rating| rating.score }.sum / ratings.count
  end
  def rated_styles
    beers.select(:style).distinct.map { |beer| beer.style}
  end
end
