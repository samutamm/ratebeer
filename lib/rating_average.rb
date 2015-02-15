module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0 if self.ratings.empty?
    (self.ratings.map{|r| r.score}.sum / self.ratings.count.to_f).round(2)
  end
end