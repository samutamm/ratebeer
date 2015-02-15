require 'rails_helper'

describe Brewery do
  it "has the name and year set correctly and is saved to database" do
    brewery = Brewery.create name:"Schlenkerla", year:1674

    expect(brewery.name).to eq("Schlenkerla")
    expect(brewery.year).to eq(1674)
    expect(brewery).to be_valid
  end

  it "without a name is not valid" do
    brewery = Brewery.create  year:1674

    expect(brewery).not_to be_valid
  end

  it "creating brewery saves it to database." do
    expect{
      Brewery.create name:'Panimo', year:'1988'
    }.to change{Brewery.count}.from(0).to(1)
  end

  it "destroying brewery deletes it from database." do
    brewery = Brewery.create name:'Panimo', year:'1988'
    expect{
      Brewery.first.destroy
    }.to change{Brewery.count}.from(1).to(0)
  end

  it 'Class method top returns the only created one' do
    b = FactoryGirl.create(:brewery)
    expect(Brewery.top(1)).to eq([b])
  end

  it 'With three breweries returns the top 2' do
    user = FactoryGirl.create(:user)
    b1 = FactoryGirl.create(:brewery)
    b2 = FactoryGirl.create(:brewery)
    b3 = FactoryGirl.create(:brewery)
    create_beer_to_brewery(b1, 10, user)
    create_beer_to_brewery(b2, 20, user)
    create_beer_to_brewery(b3, 30, user)
    expect(Brewery.top(2)).to eq([b3, b2])
  end
end

def create_beer_to_brewery(brewery, score, user)
  beer = FactoryGirl.create(:beer, brewery:brewery)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
end