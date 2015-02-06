require 'rails_helper'

describe "Breweries page" do
  it "should not have any before been created" do
    visit breweries_path
    expect(page).to have_content 'Listing breweries'
    expect(page).to have_content 'Number of breweries: 0'
  end

  describe "when breweries exists" do
    before :each do
      @breweries = ["Koff", "Karjala", "Schlenkerla"]
      year = 1896
      @breweries.each do |brewery_name|
        FactoryGirl.create(:brewery, name: brewery_name, year: year += 1)
      end

      FactoryGirl.create(:user)
      sign_in(username:"Pekka", password:"Foobar1")
      visit breweries_path
    end

    it "lists the breweries and their total number" do
      expect(page).to have_content "Number of breweries: #{@breweries.count}"
      @breweries.each do |brewery_name|
        expect(page).to have_content brewery_name
      end
    end

    it "allows user to navigate to page of a Brewery" do
      click_link "Koff"

      expect(page).to have_content "Koff"
      expect(page).to have_content "Established in 1897"
    end

    it 'can create new Brewery' do
      click_link('New Brewery')
      fill_in('brewery_name', with:'Panimo')
      fill_in('brewery_year', with:1999)
      expect{
        click_button('Create Brewery')
      }.to change{Brewery.count}.from(3).to(4)
    end

    it 'get redirection if given name missing.' do
      click_link('New Brewery')
      fill_in('brewery_name', with:'')
      fill_in('brewery_year', with:1999)

      click_button('Create Brewery')
      expect(page).to have_content 'Name can\'t be blank'
    end

  end
end