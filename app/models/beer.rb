class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def to_s
    "#{self.name} | #{brewery.name}"
  end

  def average_rating
    self.ratings.inject(0.0) { |sum, n| sum += n.score  } / self.ratings.count
  end
end
