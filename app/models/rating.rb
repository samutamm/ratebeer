class Rating < ActiveRecord::Base
  belongs_to :beer

  def to_s
    "#{beer.name} | #{score}"
  end

  def average_rating
    beer.ratings.average(:score).to_f
  end
end
