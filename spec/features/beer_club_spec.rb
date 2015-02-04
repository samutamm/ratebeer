require 'rails_helper'

describe "Beer club page" do

  before :each do
    FactoryGirl.create(:user)
    sign_in(username:"Pekka", password:"Foobar1")
    visit beer_clubs_path
  end

  it "should show all created BeerClubs" do
    expect(page).to_not have_content 'Show'
    expect(page).to_not have_content 'Delete'
  end
end