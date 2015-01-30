class RatingsController < ApplicationController

  def index
    @ratings = Rating.all
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create

    @rating = Rating.create params.require(:rating).permit(:score, :beer_id)

    if @rating.id.nil?
      @beers = Beer.all
      render :new
    else
      current_user.ratings << @rating
      redirect_to current_user
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete
    redirect_to :back
  end

end