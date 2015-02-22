class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  has_many :ratings
  has_many :memberships
  has_many :confirmed_memberships, -> {where confirmed: true}, class_name: "Membership"
  has_many :unconfirmed_memberships, -> {where confirmed: [false, nil]}, class_name: "Membership"
  has_many :beer_clubs, through: :confirmed_memberships, source: :beer_club
  has_many :applied_memberships, through: :unconfirmed_memberships, source: :beer_club

  has_many :beers, through:  :ratings
  has_many :styles, through: :beers

  validates :username, uniqueness: true
  validates :username, length: { minimum: 3,
                                 maximum: 15 }
  validates_format_of :password, :with => /\A^(?=.*?[A-Z])(?=.*?[0-9]).{4,}$\Z/i

  def to_s
    "#{self.username}"
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = self.all.sort_by{ |b| -(b.ratings.count||0) }
    sorted_by_rating_in_desc_order.take(n)
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.sort_by{ |r| r.score }.last.beer
  end

  def favorite(category)
    return nil if ratings.empty?
    category_ratings = rated(category).inject([]) do |set, item|
      set << {
          item: item,
          rating: rating_of(category, item) }
    end

    category_ratings.sort_by { |item| item[:rating] }.last[:item]
  end

  def favorite_brewery
    favorite(:brewery)
  end

  def favorite_style
    favorite(:style)
  end

  def rated(category)
    ratings.map{ |r| r.beer.send(category) }.uniq
  end

  def rating_of(category, item)
    ratings_of_item = ratings.select do |r|
      r.beer.send(category) == item
    end
    ratings_of_item.map(&:score).sum / ratings_of_item.count
  end
end
