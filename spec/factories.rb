
FactoryGirl.define do
  factory :user do
    username "Pekka"
    password "Foobar1"
    password_confirmation "Foobar1"
  end

  factory :style, class: Style do
    name "Lager"
    description "kuvaus"
  end

  factory :beer_club, class: BeerClub do
    name "olutklubi"
    founded 1862
    city "Toronto"
  end

  factory :rating do
    score 10
  end

  factory :rating2, class: Rating do
    score 20
  end

  factory :brewery do
    name "anonymous"
    year 1900
  end

  factory :brewery2, class: Brewery do
    name "anonymoussy"
    year 1903
  end

  factory :beer do
    name "anonymous"
    brewery
    style
  end

  factory :place, class: Place do
    name "Oljenkorsi"
    id 1
  end
  factory :place2, class: Place do
    name "Weinsten"
    id 2
  end
end