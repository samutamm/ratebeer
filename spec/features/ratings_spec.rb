require 'rails_helper'

include OwnTestHelper

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  describe "listing all page" do
    it 'when no ratings, page should tell that.' do
      visit ratings_path
      expect(page).to have_content '0.0'
      expect(page).to have_content '0'
    end

    it 'when there are ratings, page should tell that.' do
      beer = FactoryGirl.create(:beer, brewery:brewery)
      FactoryGirl.create(:rating, score:10, beer:beer, user:user)

      visit ratings_path
      expect(page).to have_content '1'
      expect(page).to have_content 'Pekka'
      expect(page).to have_content  beer.name
      expect(page).to have_content  beer.style

    end
  end
end