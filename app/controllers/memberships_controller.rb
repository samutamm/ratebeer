class MembershipsController < ApplicationController

  def new
    @membership = Membership.new

    current_users_clubs = current_user.beer_clubs.to_set
    @beer_clubs = BeerClub.all.to_set.delete_if {|x| current_users_clubs.include?(x)}
  end

  def create
    @membership = Membership.new params.require(:membership).permit(:beer_club_id)

    current_user.memberships << @membership
    redirect_to current_user
  end

  def destroy

  end
end