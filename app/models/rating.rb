class Rating < ActiveRecord::Base
  belongs_to :beer
  belongs_to :user

  validates :score, numericality: {
                      less_than: 51
                  }

  def to_s
    "#{beer.name} | #{score}"
  end
end
