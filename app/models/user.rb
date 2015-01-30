class User < ActiveRecord::Base
  include RatingAverage
  has_many :ratings

  validates :username, uniqueness: true
  validates :username, length: { minimum: 5 }
end
