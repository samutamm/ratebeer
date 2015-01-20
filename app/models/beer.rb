class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def to_s
    "#{self.name} | #{brewery.name}"
  end
end
