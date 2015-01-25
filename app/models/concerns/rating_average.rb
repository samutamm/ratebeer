module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0 if self.ratings.empty?
    self.ratings.map{|r| r.score}.sum / self.ratings.count.to_f
    #self.ratings.inject(0.0) { |sum, n| sum += n.score  } / self.ratings.count
  end
end