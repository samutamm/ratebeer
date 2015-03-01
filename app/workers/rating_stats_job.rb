class RatingStatsWorker
  include Sidekiq::Worker

  def perform(*args)
    expr_min = 2
    while true do
      Rails.cache.write("MOI", 'MOI')
      Rails.cache.write("beer top 3", Beer.top(3), expires_in: expr_min)
      Rails.cache.write("brewery top 3", Brewery.top(3), expires_in: expr_min)
      Rails.cache.write("rater top 3", User.top(3),expires_in: expr_min)
      Rails.cache.write("style top 3", Style.top(3), expires_in: expr_min)
      Rails.cache.write("recent", Rating.recent, expires_in: expr_min)
      sleep expr_min.minutes
    end
  end
end
