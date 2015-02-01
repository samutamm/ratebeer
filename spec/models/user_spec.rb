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
end
