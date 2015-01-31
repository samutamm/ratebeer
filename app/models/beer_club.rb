class BeerClub < ActiveRecord::Base
  has_many :memberships
  has_many :members, through: :memberships, source: :user

  def to_s
    "#{self.name}  | #{self.city}"
  end
end
