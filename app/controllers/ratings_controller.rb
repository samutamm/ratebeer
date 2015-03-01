class RatingsController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index, :show]
  #before_action :check_that_cache_is_not_empty, only: [:index]

  def calculate_stats_until_cache_is_ready
    @ratings = Rating.includes(:beer, :user).all
    @top_beers =  Beer.top(3)
    @top_breweries = Brewery.top(3)
    @top_raters = User.top(3)
    @top_styles = Style.top(3)
    @recent = Rating.recent
  end

  # ei toimi shitti eikä oo enää aikaa vääntää
  def check_that_cache_is_not_empty
    if Rails.cache.read('beer top 3').nil?
      RatingStatsWorker.perform_async
      calculate_stats_until_cache_is_ready
      render :index
    end
  end

  def index
    calculate_stats_until_cache_is_ready
=begin
    @ratings = Rating.includes(:beer, :user).all
    #@ratings = Rating.all
    @top_beers = Rails.cache.read 'beer top 3'
    @top_breweries = Rails.cache.read 'brewery top 3'
    @top_raters = Rails.cache.read 'rater top 3'
    @top_styles = Rails.cache.read 'style top 3'
    @recent = Rails.cache.read 'recent'
=end
  end

  def new
    @rating = Rating.new
    @beers = Beer.includes(:brewery).all
  end

  def create
    if @rating.nil?
      @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    end
    if @rating.save
      current_user.ratings << @rating
      redirect_to current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end

end