class BreweriesController < ApplicationController
  before_action :set_brewery, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :ensure_that_is_admin, only: [:destroy]
  before_action :skip_if_cached, only: [:index]
  before_action :expire_fragment_if_content_changed, only: [:update, :destroy, :create]

  def expire_fragment_if_content_changed
    expire_fragment('brewerylist')
  end

  def skip_if_cached
    return render :index if fragment_exist?( 'brewerylist'  )
  end

  def index
    @active_breweries = Brewery.active
    @retired_breweries = Brewery.retired
    order = params[:order] || 'name'
    @active_breweries = case order
                          when 'name' then @active_breweries.sort_by{ |b| b.name }
                          when 'year' then @active_breweries.sort_by{ |b| b.year }
                        end
    @retired_breweries = case order
                          when 'name' then @retired_breweries.sort_by{ |b| b.name }
                          when 'year' then @retired_breweries.sort_by{ |b| b.year }
                         end

    if session[:last_order_for_breweries] == order
      @active_breweries.reverse!
      @retired_breweries.reverse!
    end
    session[:last_order_for_breweries] = order
  end

  def list
  end

  def show
  end

  def new
    @brewery = Brewery.new
  end

  def edit
  end

  def create
    @brewery = Brewery.new(brewery_params)

    respond_to do |format|
      if @brewery.save
        format.html { redirect_to breweries_path, notice: 'Brewery was successfully created.' }
        format.json { render :show, status: :created, location: @brewery }
      else
        format.html { render :new }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @brewery.update(brewery_params)
        format.html { redirect_to @brewery, notice: 'Brewery was successfully updated.' }
        format.json { render :show, status: :ok, location: @brewery }
      else
        format.html { render :edit }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @brewery.destroy
    respond_to do |format|
      format.html { redirect_to breweries_url, notice: 'Brewery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def toggle_activity
    brewery = Brewery.find(params[:id])
    brewery.update_attribute :active, (not brewery.active)

    new_status = brewery.active? ? "active" : "retired"

    redirect_to :back, notice:"brewery activity status changed to #{new_status}"
  end

  private
    def set_brewery
      @brewery = Brewery.find(params[:id])
    end

    def brewery_params
      params.require(:brewery).permit(:name, :year, :active)
    end

    def authenticate
      admin_accounts = { "admin" => "secret", "pekka" => "beer", "arto" => "foobar", "matti" => "ittam"}

      authenticate_or_request_with_http_basic do |username, password|
        admin_accounts[username] == password
      end
    end
end
