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
end