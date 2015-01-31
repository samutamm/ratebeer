class User < ActiveRecord::Base
  include RatingAverage
  has_many :ratings

  validates :username, uniqueness: true
  validates :username, length: { minimum: 3,
                                 maximum: 15 }

  def to_s
    "#{self.username}"
  end
end
