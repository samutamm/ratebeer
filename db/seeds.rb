# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
b1 = Brewery.create name:"Koff", year:1897
b2 = Brewery.create name:"Malmgard", year:2001
b3 = Brewery.create name:"Weihenstephaner", year:1042

s1 = Style.create name:"Weizen", description:"http://www.beeradvocate.com/beer/style/"
s2 = Style.create name:"Lager", description:"http://www.beeradvocate.com/beer/style/"
s3 = Style.create name:"Pale ale", description:"http://www.beeradvocate.com/beer/style/"
s4 = Style.create name:"IPA", description:"http://www.beeradvocate.com/beer/style/"
s5 = Style.create name:"Porter", description:"http://www.beeradvocate.com/beer/style/"

b1.beers.create name:"Iso 3", style_id:s2.id
b1.beers.create name:"Karhu", style_id:s2.id
b1.beers.create name:"Tuplahumala", style_id:s2.id
b2.beers.create name:"Huvila Pale Ale", style_id:s3.id
b2.beers.create name:"X Porter", style_id:s5.id
b3.beers.create name:"Hefezeizen", style_id:s1.id
b3.beers.create name:"Helles", style_id:s2.id