require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    place = Place.new( name:"Oljenkorsi", id: 1 )
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return([ place ])

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if multiple place are returned by the API, all of them are shown on page." do
    place1 = Place.new( name:"Oljenkorsi", id: 1 )
    place2 = Place.new( name:"Weinstein", id: 2 )
    places = [place1, place2]
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(places)

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"
    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Weinstein"
  end

  it "if none is returned by the API, it is noticed" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return([])

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"
    expect(page).to have_content "No locations in kumpula"
  end

  it "if the search keyword is empty, it is noticed" do
    visit places_path
    fill_in('city', with: '')
    click_button "Search"
    expect(page).to have_content "Please give the name of city."
  end
end