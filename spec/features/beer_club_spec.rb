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

  it 'should list just created clubs.' do
    expect{
      FactoryGirl.create(:beer_club, name:"klubben")
      FactoryGirl.create(:beer_club, name:"buu")
    }.to change{BeerClub.count}.from(0).to(2)

    visit beer_clubs_path
    expect(page).to have_content 'buu'
    expect(page).to have_content 'klubben'
  end

  it 'clicking show method should render clubs page.' do
    FactoryGirl.create(:beer_club, name:"klubben")
    visit beer_clubs_path

    click_link('Show')
    expect(page).to have_content 'The club has not yet any members'
  end

  it 'clicking show method should render clubs page.' do
    FactoryGirl.create(:beer_club, name:"klubben")
    visit beer_clubs_path

    click_link('Edit')
    expect(page).to have_content 'Editing Beer'
    fill_in('beer_club_name', with:'Polololo')
    click_button('Update Beer club')
    expect(page).to have_content 'Polololo'
  end

end