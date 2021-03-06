require 'rails_helper'

include OwnTestHelper

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with:'Brian')
      fill_in('user_password', with:'Secret55')
      fill_in('user_password_confirmation', with:'Secret55')


      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end
  end

  describe "user page" do
    it 'should list all made ratings' do
      user = User.first
      beer = make_rating_to_user(user)

      visit user_path(user)
      expect(page).to have_content beer.name
    end

    it 'should list favorite style and brewery.' do
      user = User.first
      beer = make_rating_to_user(user)

      visit user_path(user)
      expect(page).to have_content 'Favorite style:'
      expect(page).to have_content 'Favorite brewery:'
    end

    it 'deleting rating should remove it from database.' do
      user = User.first
      make_rating_to_user(user)
      sign_in(username:"Pekka", password:"Foobar1")

      visit user_path(user)
      expect{
        click_on('delete')
      }.to change{Rating.count}.by(-1)
    end
  end
end

def make_rating_to_user(user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:10, beer:beer, user:user)
  beer
end

BeerClub
BeerClubsController