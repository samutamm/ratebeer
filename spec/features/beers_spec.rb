require 'rails_helper'

describe "New beer page" do

  before :each do
    FactoryGirl.create(:user)
    sign_in(username:"Pekka", password:"Foobar1")
    visit new_beer_path
  end

  it "should have forms for new beer." do
    expect(page).to have_content 'New Beer'
    expect(page).to have_content 'Name'
    expect(page).to have_content 'Style'
    expect(page).to have_content 'Brewery'
  end

  it "creates new beer with valid name." do
    FactoryGirl.create(:style)
    visit new_beer_path
    fill_in('beer_name', with:"Kalja")
    select "Lager", :from => 'beer_style_id'

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "does not create new beer with invalid name." do
    fill_in('beer_name', with:" ")

    click_button ("Create Beer")
    expect(Beer.count).to eq(0)
    expect(page).to have_content 'Name can\'t be blank'
  end

end