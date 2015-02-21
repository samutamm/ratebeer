class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]

  def index
    @memberships = Membership.all
  end

  def show
  end

  def confirm_membership
    membership = Membership.find(params[:id])
    membership.update_attribute(:confirmed, true)

    redirect_to :back, notice: "Membership confirmed!"
  end

  def new
    @beer_clubs = BeerClub.all.reject{ |b| b.members.include? current_user }
    @membership = Membership.new
  end

  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = Membership.new(membership_params)
    @membership.user = current_user

    respond_to do |format|
      if @membership.save
        format.html { redirect_to beer_club_path(@membership.beer_club_id), notice: current_user.username + ", welcome to the club!" }
        format.json { render :show, status: :created, location: @membership }
      else
        @beer_clubs = BeerClub.all.reject{ |b| b.members.include? current_user }
        format.html { render :new }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    user_id = @membership.user_id
    club = BeerClub.find(@membership.beer_club_id)
    @membership.destroy

    if club.memberships.count == 0
      club.destroy
    end
    respond_to do |format|
      format.html { redirect_to user_path(user_id), notice: 'Membership was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def membership_params
    params.require(:membership).permit(:user_id, :beer_club_id, :confirmed)
  end
end