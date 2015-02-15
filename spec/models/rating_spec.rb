require 'rails_helper'

describe Rating do

  before :each do
    @ratings_id = []
    5.times do
      rating = FactoryGirl.create(:rating)
      @ratings_id.append(rating.id)
    end
  end

  it 'scope recent returns all ratings if only 5 created' do
    recent = Rating.recent
    @ratings_id.each do |rating_id|
     expect(include_helper(recent, rating_id)).to be(true)
    end
  end

  it 'after creating newer ratings, scope should return those' do
    newest = FactoryGirl.create(:rating)
    ratings_id = @ratings_id.drop(1)
    ratings_id.append(newest.id)
    recent = Rating.recent
    ratings_id.each do |rating_id|
      expect(include_helper(recent, rating_id)).to be(true)
    end
  end

  def include_helper(recent, id)
    (recent.find {|elem| elem.id == id}) != nil
  end


end