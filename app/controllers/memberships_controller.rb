class MembershipsController < ApplicationController

  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all
  end

  def create
    @membership = Membership.new params.require(:membership).permit(:beer_club_id)

    current_user.memberships << @membership
    redirect_to current_user
  end

  def destroy

  end
end