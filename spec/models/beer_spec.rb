require 'rails_helper'

describe Beer do
  it "with name and style is saved." do
    beer = Beer.create name:"Kalja", style_id:1

    expect(beer.valid?).to be(true)
    expect(Beer.count).to eq(1)
  end

  it "without name is not saved." do
    beer = Beer.create style_id:1

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

  it "without style is not saved." do
    beer = Beer.create name:"lager beer"

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

end
