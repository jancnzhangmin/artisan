class Bartask < ApplicationRecord
  belongs_to :user
  has_many :measures
  has_many :bartaskdetails
  has_many :transits
  has_many :fingers
  has_many :improves
  has_many :openlocks
  has_many :offers
end
