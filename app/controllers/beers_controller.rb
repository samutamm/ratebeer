class BeersController < ApplicationController
  before_action :set_beer, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, except: [:index, :show, :list, :nglist]
  before_action :ensure_that_is_admin, only: [:destroy]


  def index
    @beers = Beer.includes(:brewery, :style).all

    order = params[:order] || 'name'

    @beers = case order
               when 'name' then @beers.sort_by{ |b| b.name }
               when 'brewery' then @beers.sort_by{ |b| b.brewery.name }
               when 'style' then @beers.sort_by{ |b| b.style.name }
             end
  end

  def list
  end

  def nglist
  end

  def show
    @rating = Rating.new
    @rating.beer = @beer
  end

  def new
    @beer = Beer.new
    set_styles_and_breweries
  end

  def edit
    set_styles_and_breweries
  end

  def create
    @beer = Beer.new(beer_params)

    respond_to do |format|
      if @beer.save
        format.html { redirect_to beers_path, notice: 'Beer was successfully created.' }
        format.json { render :show, status: :created, location: @beer }
      else
        format.html { render :new }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
        set_styles_and_breweries
      end
    end
  end

  def update
    respond_to do |format|
      if @beer.update(beer_params)
        format.html { redirect_to @beer, notice: 'Beer was successfully updated.' }
        format.json { render :show, status: :ok, location: @beer }
      else
        format.html { render :edit }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @beer.destroy
    respond_to do |format|
      format.html { redirect_to beers_url, notice: 'Beer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_beer
      @beer = Beer.find(params[:id])
    end

    def set_styles_and_breweries
      @styles = Style.all
      @breweries = Brewery.all
    end

    def beer_params
      params.require(:beer).permit(:name, :style_id, :brewery_id)
    end
end
