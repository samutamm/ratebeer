class Rating < ActiveRecord::Base
  belongs_to :beer

  def to_s
    "#{beer.name} | #{score}"
  end

  def average_rating
    score_sum = 0.0
    beer.ratings.each {|rating| score_sum += rating.score}
    score_sum / beer.ratings.count
  end
end
