class Rating < ActiveRecord::Base
  belongs_to :beer

  def to_s
    "#{beer.name} pisteita #{score}"
  end
end
