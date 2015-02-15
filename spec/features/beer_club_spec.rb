require 'rails_helper'

describe "Beer club page" do

  before :each do
    FactoryGirl.create(:user)
    sign_in(username:"Pekka", password:"Foobar1")
    visit beer_clubs_path
  end

  it "should not show anything before creating BeerClubs" do
    expect(page).to_not have_link 'Show'
    expect(page).to_not have_link 'Delete'
  end

  it 'should list just created clubs.' do
    expect{
      FactoryGirl.create(:beer_club, name:"klubben")
      FactoryGirl.create(:beer_club, name:"buu")
    }.to change{BeerClub.count}.from(1).to(3)

    visit beer_clubs_path
    expect(page).to have_content 'buu'
    expect(page).to have_content 'klubben'
  end

  before :each do
    FactoryGirl.create(:beer_club, name:"klubb")
  end

  it 'clicking show method should render clubs page.' do
    visit beer_clubs_path

    click_link('Show')
    expect(page).to have_content 'The club has not yet any members'
  end

  it 'clubs page should have edit feature.' do
    visit beer_clubs_path
    click_link('Show')
    click_link('Edit')
    expect(page).to have_content 'Editing Beer'
    fill_in('beer_club_name', with:'Polololo')
    click_button('Update Beer club')
    expect(page).to have_content 'Polololo'
  end

  it 'delete feature destroys from database', :js => false do
    sign_in(username:"Pekka", password:"Foobar1")
    visit beer_clubs_path
    click_link('Show')

    expect{
      click_link('Destroy')
    }.to change{BeerClub.count}.from(1).to(0)

  end

end