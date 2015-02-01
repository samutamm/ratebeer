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
end
