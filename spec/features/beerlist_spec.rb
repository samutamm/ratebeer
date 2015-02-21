require 'rails_helper'

describe "Beerlist page" do

  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(allow_localhost:true)
  end

  before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @brewery1 = FactoryGirl.create(:brewery, name: "Koff")
    @brewery2 = FactoryGirl.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryGirl.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryGirl.create(:beer, name: "Nikolai", brewery: @brewery1, style: @style1)
    @beer2 = FactoryGirl.create(:beer, name: "Fastenbier", brewery: @brewery2, style: @style2)
    @beer3 = FactoryGirl.create(:beer, name: "Lechte Weisse", brewery: @brewery3, style: @style3)
  end

  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end

  it "shows one known beer", js:true do
    visit beerlist_path
    rivi = page.find('table').find('tr:nth-child(2)')
    #byebug
    expect(page).to have_content "Nikolai"
  end

  it "shows beers in alphabetical order by name", js:true do
    visit beerlist_path
    rivi1 = page.find('table').find('tr:nth-child(2)').text
    rivi2 = page.find('table').find('tr:nth-child(3)').text
    rivi3 = page.find('table').find('tr:nth-child(4)').text
    expect(rivi1).to have_content 'Fastenbier'
    expect(rivi2).to have_content 'Lechte Weisse'
    expect(rivi3).to have_content 'Nikolai'
  end

  it "when clicking style, js sorts beers by style", js:true do
    visit beerlist_path
    click_link('style')
    expect(page.find('table').find('tr:nth-child(2)').text).to have_content 'Lager'
    expect(page.find('table').find('tr:nth-child(3)').text).to have_content 'Rauchbier'
    expect(page.find('table').find('tr:nth-child(4)').text).to have_content 'Weizen'
  end
end