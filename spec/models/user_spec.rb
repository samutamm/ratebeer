require 'rails_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      rating = FactoryGirl.create(:rating)
      rating2 = FactoryGirl.create(:rating2)

      user.ratings << rating
      user.ratings << rating2

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
  describe "with a password " do
    it "that is too short, user is not saved." do
      user = User.create username:"Pekka", password:"Sa1", password_confirmation:"Sa1"

      expect(user.valid?).to be(false)
      expect(User.count).to eq(0)
    end

    it "that does not contain any digits, user is not saved." do
      user = User.create username:"Pekka", password:"Salasana", password_confirmation:"Salasana"

      expect(user.valid?).to be(false)
      expect(User.count).to eq(0)
    end
  end
  describe "favorite beer " do
    let(:user){ FactoryGirl.create(:user)}
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)
      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings([10, 20, 15, 7, 9], user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryGirl.create(:user)}
    it "has method for detemining one " do
      expect(user).to respond_to(:favorite_style)
    end
    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end
    it "is the only rated if only one rating" do
      style = styles(1)
      create_beer_with_rating(10, user, style)
      expect(user.favorite_style).to eq(style)
    end

    it "is the one with highest rating average." do
      style_1 = styles(0)
      style_2 = styles(3)
      create_beers_with_ratings([5, 10, 15], user, style_1)
      create_beer_with_rating(30, user, style_2)

      expect(user.favorite_style).to eq(style_2)
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryGirl.create(:user)}
    it "has method for detemining one " do
      expect(user).to respond_to(:favorite_brewery)
    end
    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end
    it "is the only rated if only one rating" do
      brewery = FactoryGirl.create(:brewery)
      create_beer_to_brewery(brewery, 10, user)
      expect(user.favorite_brewery).to eq(brewery)
    end
    it "is the one with highest rating average." do
      b1 = FactoryGirl.create(:brewery)
      b2 = FactoryGirl.create(:brewery2)
      create_beer_to_brewery(b1, 10, user)
      create_beer_to_brewery(b2, 20, user)
      create_beer_to_brewery(b2, 4, user)
      expect(user.favorite_brewery).to eq(b2)
    end
  end
end

def create_beer_to_brewery(brewery, score, user)
  beer = FactoryGirl.create(:beer, brewery:brewery)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
end

def create_beer_with_rating(score, user, beer_style=styles(1))
  beer = FactoryGirl.create(:beer, style:beer_style)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(scores, user, beer_style=styles(1))
  scores.each do |score|
    create_beer_with_rating(score, user, beer_style)
  end
end

def styles(index)
  style_name = ["Weizen", "Lager", "Pale ale", "IPA", "Porter"][index]
  Style.create name:style_name, description:"blaablaa"
end
